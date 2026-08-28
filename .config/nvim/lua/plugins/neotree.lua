return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    {
      's1n7ax/nvim-window-picker',
      version = '2.*',
      config = function()
        require('window-picker').setup {
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
              buftype = { 'terminal', 'quickfix' },
            },
          },
        }
      end,
    },
  },
  config = function()
    require('neo-tree').setup {
      popup_border_style = 'rounded',
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      default_component_configs = {
        icon = {
          folder_empty = '󰜌',
        },
        modified = {
          symbol = '[+]',
        },
        git_status = {
          symbols = {
            added = '',
            modified = '',
          },
        },
        type = {
          required_width = 122,
        },
        created = {
          enabled = true,
          required_width = 110,
        },
      },
      window = {
        mappings = {
          l = 'open',
          i = 'show_file_details',
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
          hide_by_name = {
            '.DS_Store',
            'thumbs.db',
            'node_modules',
            '__pycache__',
            '.virtual_documents',
            '.git',
            '.python-version',
            '.venv',
          },
        },
      },
      buffers = {
        show_unloaded = true,
        window = {
          mappings = {
            d = 'delete',
          },
        },
      },
      git_status = {
        window = {
          position = 'float',
        },
      },
    }

    vim.keymap.set('n', '\\', '<cmd>Neotree reveal<CR>', { desc = 'Reveal file in Neo-tree' })
    vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle position=left<CR>', { desc = 'Toggle Neo-tree' })
    vim.keymap.set('n', '<leader>ngs', '<cmd>Neotree float git_status<CR>', { desc = 'Open Git status' })
  end,
}
