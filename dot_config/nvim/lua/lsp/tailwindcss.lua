-- - Root directory: ~/work/cord-frontend/apps/encord-fe
-- - Command: { "/Users/encord/.asdf/shims/tailwindcss-language-server", "--stdio" }
-- - Settings: {
--     editor = {
--       tabSize = 2
--     },
--     tailwindCSS = {
--       classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
--       includeLanguages = {
--         eelixir = "html-eex",
--         eruby = "erb",
--         htmlangular = "html",
--         templ = "html"
--       },
--       lint = {
--         cssConflict = "warning",
--         invalidApply = "error",
--         invalidConfigPath = "error",
--         invalidScreen = "error",
--         invalidTailwindDirective = "error",
--         invalidVariant = "error",
--         recommendedVariantOrder = "warning"
--       },
--       validate = true
--     }
--   }

return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "aspnetcorerazor",
    "astro",
    "astro-markdown",
    "blade",
    "clojure",
    "django-html",
    "htmldjango",
    "edge",
    "eelixir",
    "elixir",
    "ejs",
    "erb",
    "eruby",
    "gohtml",
    "gohtmltmpl",
    "haml",
    "handlebars",
    "hbs",
    "html",
    "htmlangular",
    "html-eex",
    "heex",
    "jade",
    "leaf",
    "liquid",
    "markdown",
    "mdx",
    "mustache",
    "njk",
    "nunjucks",
    "php",
    "razor",
    "slim",
    "twig",
    "css",
    "less",
    "postcss",
    "sass",
    "scss",
    "stylus",
    "sugarss",
    "javascript",
    "javascriptreact",
    "reason",
    "rescript",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "templ",
  },
  settings = {
    tailwindCSS = {
      classAttributes = {
        "class",
        "className",
        "class:list",
        "classList",
        "ngClass",
      },
      includeLanguages = {
        eelixir = "html-eex",
        eruby = "erb",
        htmlangular = "html",
        templ = "html",
      },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning",
      },
      validate = true,
    },
  },
}
