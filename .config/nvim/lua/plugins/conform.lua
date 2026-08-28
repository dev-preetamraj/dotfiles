return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format {
          async = true,
          lsp_format = 'never',
        }
      end,
      mode = { 'n', 'v' },
      desc = '[F]ormat buffer or selection',
    },
  },
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
  },
}
