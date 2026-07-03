return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format' },
      typescriptreact = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      javascript = { 'prettier' },
      json = { 'prettier' },
      css = { 'prettier' },
      html = { 'prettier' },
      markdown = { 'prettier' },
    },

    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
