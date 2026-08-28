return {
  {
    'esmuellert/codediff.nvim',
    cmd = 'CodeDiff',
    keys = {
      { '<leader>gs', '<cmd>CodeDiff<CR>', desc = '[G]it [S]tatus and diffs' },
      { '<leader>gh', '<cmd>CodeDiff history<CR>', desc = '[G]it [H]istory' },
      { '<leader>gH', '<cmd>CodeDiff history %<CR>', desc = '[G]it current file [H]istory' },
    },
    opts = {
      highlights = {
        line_insert = '#24342c',
        line_delete = '#38272e',
        char_insert = '#24342c',
        char_delete = '#38272e',
      },
      diff = {
        layout = 'inline',
        gutter_signs = false,
      },
      explorer = {
        position = 'left',
        initial_focus = 'explorer',
        auto_open_on_cursor = true,
      },
      keymaps = {
        view = {
          quit = { 'q', '<Esc>' },
        },
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      { '<leader>gb', '<cmd>Gitsigns blame_line<CR>', desc = '[G]it [B]lame current line' },
      { '<leader>gB', '<cmd>Gitsigns blame<CR>', desc = '[G]it full file [B]lame' },
      { '<leader>gt', '<cmd>Gitsigns toggle_current_line_blame<CR>', desc = '[G]it [T]oggle inline blame' },
    },
    opts = {
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 750,
        virt_text_pos = 'eol',
      },
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'
        local function map(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map(']h', function()
          gitsigns.nav_hunk 'next'
        end, 'Next Git hunk')
        map('[h', function()
          gitsigns.nav_hunk 'prev'
        end, 'Previous Git hunk')
        map('<leader>hp', gitsigns.preview_hunk_inline, '[H]unk [P]review')
        map('<leader>hs', gitsigns.stage_hunk, '[H]unk [S]tage')
        map('<leader>hr', gitsigns.reset_hunk, '[H]unk [R]eset')
      end,
    },
  },
}
