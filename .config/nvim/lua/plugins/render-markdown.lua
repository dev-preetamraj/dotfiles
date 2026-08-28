return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = 'markdown',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    enabled = true,
  },
  keys = {
    {
      '<leader>mp',
      '<cmd>RenderMarkdown buf_toggle<CR>',
      desc = 'Toggle Markdown preview',
    },
  },
}
