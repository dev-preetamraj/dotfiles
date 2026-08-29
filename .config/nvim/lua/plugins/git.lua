local function open_merge(filename)
  vim.cmd('CodeDiff merge ' .. vim.fn.fnameescape(filename))
end

local function open_git_status_or_conflicts()
  local filename = vim.api.nvim_buf_get_name(0)
  local cwd = assert(vim.uv.cwd())
  local git_root = vim.fs.root(filename ~= '' and filename or cwd, '.git') or vim.fs.root(cwd, '.git')

  if not git_root then
    vim.cmd.CodeDiff()
    return
  end

  local result = vim.system({ 'git', '-C', git_root, 'diff', '--name-only', '--diff-filter=U', '-z' }, { text = true }):wait()
  if result.code ~= 0 then
    vim.cmd.CodeDiff()
    return
  end

  local conflicts = vim.split(result.stdout or '', '\0', { plain = true, trimempty = true })
  if #conflicts == 0 then
    vim.cmd.CodeDiff()
  elseif #conflicts == 1 then
    open_merge(vim.fs.joinpath(git_root, conflicts[1]))
  else
    vim.ui.select(conflicts, { prompt = 'Resolve merge conflict' }, function(choice)
      if choice then
        open_merge(vim.fs.joinpath(git_root, choice))
      end
    end)
  end
end

return {
  {
    'esmuellert/codediff.nvim',
    cmd = 'CodeDiff',
    keys = {
      { '<leader>gs', open_git_status_or_conflicts, desc = '[G]it [S]tatus or resolve conflicts' },
      {
        '<leader>gm',
        function()
          local filename = vim.api.nvim_buf_get_name(0)
          if filename == '' then
            vim.notify('Current buffer is not a file', vim.log.levels.WARN)
            return
          end

          open_merge(filename)
        end,
        desc = '[G]it [M]erge current conflicted file',
      },
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
