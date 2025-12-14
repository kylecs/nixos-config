local java_home = os.getenv("JAVA_HOME")
return {
  "mfussenegger/nvim-jdtls",
  config = function()
    vim.lsp.config("jdtls", {
      root_markers = { "build.gradle", "build.gradle.kts", "gradlew.bat", "pom.xml", ".git" },
      filetypes = { "java" },
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = java_home,
                default = true,
              },
            },
          },
        },
      },
    })
    vim.lsp.enable("jdtls")
  end,
}
