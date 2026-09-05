return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    local catppuccin = require 'catppuccin'
    local transparent = false

    local function apply_theme()
      catppuccin.setup {
        flavour = 'macchiato',
        transparent_background = transparent,
        float = {
          transparent = transparent,
          solid = false,
        },
        term_colors = true,
        no_italic = false,
        no_bold = false,
        auto_integrations = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          indent_blankline = {
            enabled = true,
          },
          neotree = true,
          telescope = {
            enabled = true,
          },
          treesitter = true,
        },
      }

      vim.cmd.colorscheme 'catppuccin-macchiato'
    end

    apply_theme()

    vim.keymap.set('n', '<leader>bg', function()
      transparent = not transparent
      apply_theme()
    end, { noremap = true, silent = true, desc = 'Toggle background transparency' })
  end,
}
