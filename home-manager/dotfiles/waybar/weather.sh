#!/usr/bin/env bash
# Fetches current weather from Open-Meteo (free, no API key) and emits
# waybar JSON. Caches responses so the API isn't hammered.
set -euo pipefail

LAT="${WEATHER_LAT:-38.8816}"      # Arlington, VA
LON="${WEATHER_LON:--77.0910}"
UNIT="${WEATHER_UNIT:-fahrenheit}" # fahrenheit | celsius
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-weather"
CACHE_FILE="$CACHE_DIR/current.json"
MIN_REFRESH_SECS="${WEATHER_MIN_REFRESH:-600}"  # 10 min

mkdir -p "$CACHE_DIR"
now=$(date +%s)

emit() { jq -cn --arg t "$1" --arg tt "$2" --arg c "$3" '{text:$t,tooltip:$tt,class:$c}'; }

should_fetch=1
[ -f "$CACHE_FILE" ] && {
  age=$(( now - $(stat -c %Y "$CACHE_FILE") ))
  [ "$age" -lt "$MIN_REFRESH_SECS" ] && should_fetch=0
}

if [ "$should_fetch" = 1 ]; then
  body=$(mktemp)
  code=$(curl -sS -o "$body" -w '%{http_code}' --max-time 8 \
    "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,weather_code,is_day,apparent_temperature,relative_humidity_2m,wind_speed_10m&temperature_unit=${UNIT}&wind_speed_unit=mph" \
    || echo "000")
  if [ "$code" = "200" ] && jq -e '.current.weather_code' "$body" >/dev/null 2>&1; then
    mv "$body" "$CACHE_FILE"
  else
    rm -f "$body"
  fi
fi

if [ ! -s "$CACHE_FILE" ]; then
  emit "weather --" "no weather data yet" "idle"
  exit 0
fi

read -r code is_day temp feels humidity wind < <(
  jq -r '
    .current
    | "\(.weather_code) \(.is_day) \(.temperature_2m) \(.apparent_temperature) \(.relative_humidity_2m) \(.wind_speed_10m)"
  ' "$CACHE_FILE"
)

# Nerd Font weather glyphs (range U+E300-E37F), built at runtime from
# UTF-8 hex so the script source stays pure ASCII (some file writers
# strip private-use Unicode chars).
G_SUN=$(printf '\xee\x8c\x8d')         # U+E30D day_sunny
G_NIGHT=$(printf '\xee\x8c\xab')       # U+E32B night_clear
G_DAY_CLOUDY=$(printf '\xee\x8c\x92')  # U+E312 day_cloudy
G_NIGHT_CLOUDY=$(printf '\xee\x8d\xbe') # U+E37E night_alt_cloudy
G_CLOUDY=$(printf '\xee\x8c\xbd')      # U+E33D cloudy
G_FOG=$(printf '\xee\x8c\x83')         # U+E303 fog
G_SHOWERS=$(printf '\xee\x8c\x89')     # U+E309 day_showers
G_RAIN=$(printf '\xee\x8c\x98')        # U+E318 rain
G_SNOW=$(printf '\xee\x8c\x9a')        # U+E31A snow
G_SLEET=$(printf '\xee\x8c\x9b')       # U+E31B sleet
G_THUNDER=$(printf '\xee\x8c\x9d')     # U+E31D thunderstorm

case "$code" in
  0)        icon_d="$G_SUN";        icon_n="$G_NIGHT";        desc="Clear" ;;
  1|2)      icon_d="$G_DAY_CLOUDY"; icon_n="$G_NIGHT_CLOUDY"; desc="Partly cloudy" ;;
  3)        icon_d="$G_CLOUDY";     icon_n="$G_CLOUDY";       desc="Overcast" ;;
  45|48)    icon_d="$G_FOG";        icon_n="$G_FOG";          desc="Fog" ;;
  51|53|55) icon_d="$G_SHOWERS";    icon_n="$G_SHOWERS";      desc="Drizzle" ;;
  56|57)    icon_d="$G_SLEET";      icon_n="$G_SLEET";        desc="Freezing drizzle" ;;
  61|63|65) icon_d="$G_RAIN";       icon_n="$G_RAIN";         desc="Rain" ;;
  66|67)    icon_d="$G_SLEET";      icon_n="$G_SLEET";        desc="Freezing rain" ;;
  71|73|75) icon_d="$G_SNOW";       icon_n="$G_SNOW";         desc="Snow" ;;
  77)       icon_d="$G_SNOW";       icon_n="$G_SNOW";         desc="Snow grains" ;;
  80|81|82) icon_d="$G_SHOWERS";    icon_n="$G_SHOWERS";      desc="Rain showers" ;;
  85|86)    icon_d="$G_SNOW";       icon_n="$G_SNOW";         desc="Snow showers" ;;
  95)       icon_d="$G_THUNDER";    icon_n="$G_THUNDER";      desc="Thunderstorm" ;;
  96|99)    icon_d="$G_THUNDER";    icon_n="$G_THUNDER";      desc="Thunderstorm w/ hail" ;;
  *)        icon_d="$G_CLOUDY";     icon_n="$G_CLOUDY";       desc="Unknown" ;;
esac

if [ "$is_day" = "1" ]; then icon="$icon_d"; else icon="$icon_n"; fi

unit_sym="°F"
[ "$UNIT" = "celsius" ] && unit_sym="°C"

temp_int=$(printf "%.0f" "$temp")
feels_int=$(printf "%.0f" "$feels")
wind_int=$(printf "%.0f" "$wind")
hum_int=$(printf "%.0f" "$humidity")

age=$(( now - $(stat -c %Y "$CACHE_FILE") ))
[ "$age" -lt 0 ] && age=0
if [ "$age" -lt 60 ]; then age_str="${age}s"
elif [ "$age" -lt 3600 ]; then age_str="$((age/60))m"
else age_str="$((age/3600))h"; fi

text=$(printf "%s %d%s" "$icon" "$temp_int" "$unit_sym")
tooltip=$(printf "Arlington, VA — %s (cached %s ago)\nFeels like: %d%s\nHumidity:   %d%%\nWind:       %d mph" \
  "$desc" "$age_str" "$feels_int" "$unit_sym" "$hum_int" "$wind_int")

emit "$text" "$tooltip" "ok"
