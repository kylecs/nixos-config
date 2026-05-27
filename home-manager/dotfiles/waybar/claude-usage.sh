#!/usr/bin/env bash
# Emits waybar JSON describing real Claude usage, fetched from the same
# /api/oauth/usage endpoint that backs Claude Code's /usage slash command.
#
# The endpoint is heavily rate-limited (retry-after measured in minutes),
# so the response is cached and only refreshed when the cache is stale
# AND we're past any 429 backoff window.
set -euo pipefail

CREDS="${CLAUDE_CREDENTIALS:-$HOME/.claude/.credentials.json}"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-claude-usage"
CACHE_FILE="$CACHE_DIR/usage.json"
BACKOFF_FILE="$CACHE_DIR/retry_after.epoch"
MIN_REFRESH_SECS="${CLAUDE_USAGE_MIN_REFRESH:-60}"    # 1 min between calls

mkdir -p "$CACHE_DIR"

emit() {
  # $1=text $2=tooltip $3=class
  jq -cn --arg t "$1" --arg tt "$2" --arg c "$3" \
    '{text:$t, tooltip:$tt, class:$c}'
}

now=$(date -u +%s)

should_fetch=1
[ -f "$CACHE_FILE" ] && {
  age=$(( now - $(stat -c %Y "$CACHE_FILE") ))
  [ "$age" -lt "$MIN_REFRESH_SECS" ] && should_fetch=0
}
[ -f "$BACKOFF_FILE" ] && [ "$now" -lt "$(cat "$BACKOFF_FILE")" ] && should_fetch=0

if [ "$should_fetch" = 1 ] && [ -r "$CREDS" ]; then
  token=$(jq -r '.claudeAiOauth.accessToken // empty' "$CREDS" 2>/dev/null || true)
  if [ -n "$token" ]; then
    headers=$(mktemp)
    body=$(mktemp)
    # Anthropic 429s requests whose User-Agent doesn't look like the real
    # Claude Code client, so we mimic it.
    code=$(curl -sS -o "$body" -D "$headers" -w '%{http_code}' \
      -H "Authorization: Bearer $token" \
      -H "User-Agent: claude-code/2.1.140" \
      -H "anthropic-version: 2023-06-01" \
      -H "Content-Type: application/json" \
      https://api.anthropic.com/api/oauth/usage || echo "000")

    if [ "$code" = "200" ]; then
      mv "$body" "$CACHE_FILE"
      rm -f "$BACKOFF_FILE"
    elif [ "$code" = "429" ]; then
      retry=$(grep -i '^retry-after:' "$headers" | awk '{print $2}' | tr -d '\r' || echo "")
      retry=${retry:-300}
      echo $(( now + retry )) > "$BACKOFF_FILE"
      rm -f "$body"
    else
      rm -f "$body"
    fi
    rm -f "$headers"
  fi
fi

if [ ! -s "$CACHE_FILE" ]; then
  emit "--" "no cached usage data yet (api rate-limited)" "idle"
  exit 0
fi

# Parse the response. Each populated field is { utilization: <0-100>, resets_at: <iso> }.
# Some fields (seven_day_opus, seven_day_sonnet) may be null depending on plan.
read -r five_pct seven_pct opus_pct sonnet_pct < <(
  jq -r '
    def pct(x): if x == null then -1 else (x | floor) end;
    "\(pct(.five_hour.utilization // null)) \(pct(.seven_day.utilization // null)) \(pct(.seven_day_opus.utilization // null)) \(pct(.seven_day_sonnet.utilization // null))"
  ' "$CACHE_FILE"
)

peak=0
for p in "$five_pct" "$seven_pct" "$opus_pct" "$sonnet_pct"; do
  [ "$p" -gt "$peak" ] && peak=$p
done

class="ok"
[ "$peak" -ge 70 ] && class="warning"
[ "$peak" -ge 90 ] && class="critical"

reset_str() {
  # jq's fromdateiso8601 can't parse fractional seconds or +HH:MM offsets,
  # so we normalize "...123456+00:00" -> "...Z" first.
  jq -r --arg k "$1" '
    (.[$k] // {}).resets_at as $r
    | if $r then
        ($r | sub("\\.[0-9]+"; "") | sub("\\+00:00$"; "Z") | fromdateiso8601) - now
        | if . < 0 then "now"
          elif . < 3600 then "\((. / 60) | floor)m"
          elif . < 86400 then "\((. / 3600) | floor)h\((. % 3600 / 60) | floor)m"
          else "\((. / 86400) | floor)d\((. % 86400 / 3600) | floor)h"
          end
      else "—" end
  ' "$CACHE_FILE"
}

age=$(( now - $(stat -c %Y "$CACHE_FILE") ))
if [ "$age" -lt 60 ]; then age_str="${age}s"
elif [ "$age" -lt 3600 ]; then age_str="$((age/60))m"
else age_str="$((age/3600))h"; fi

# Bar text: always show session + weekly (these are always populated).
text=$(printf "session %d%%  weekly %d%%" "$five_pct" "$seven_pct")

# Tooltip: only include lines for fields the API actually returned.
line() {
  local label=$1 pct=$2 reset=$3
  [ "$pct" -lt 0 ] && return
  printf "%-15s %d%% — resets in %s\n" "$label" "$pct" "$reset"
}
tooltip=$(printf "Claude /usage (cached %s ago)\n" "$age_str"
  line "session (5h):"   "$five_pct"   "$(reset_str five_hour)"
  line "weekly (7d):"    "$seven_pct"  "$(reset_str seven_day)"
  line "weekly Opus:"    "$opus_pct"   "$(reset_str seven_day_opus)"
  line "weekly Sonnet:"  "$sonnet_pct" "$(reset_str seven_day_sonnet)"
)

emit "$text" "$tooltip" "$class"
