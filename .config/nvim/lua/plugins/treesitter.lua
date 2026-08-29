return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  },
  config = function()
    local treesitter = require 'nvim-treesitter'
    local ensure_installed = {
      'lua',
      'python',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'regex',
      'terraform',
      'sql',
      'dockerfile',
      'toml',
      'json',
      'java',
      'groovy',
      'go',
      'gitignore',
      'graphql',
      'yaml',
      'make',
      'cmake',
      'markdown',
      'markdown_inline',
      'bash',
      'tsx',
      'css',
      'html',
      'query',
    }

    treesitter.setup()
    treesitter.install(ensure_installed)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
      callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end

        if args.match == 'ruby' then
          vim.bo[args.buf].syntax = 'on'
        else
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    vim.keymap.set({ 'n', 'x' }, '<C-g>', function()
      vim.treesitter.select 'parent'
    end, { desc = 'Select parent syntax node' })
    vim.keymap.set('x', '<BS>', function()
      vim.treesitter.select 'child'
    end, { desc = 'Select child syntax node' })

    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = true,
      },
      move = { set_jumps = true },
    }

    local select = require 'nvim-treesitter-textobjects.select'
    local select_mappings = {
      ['a='] = { '@assignment.outer', 'Select outer part of an assignment' },
      ['i='] = { '@assignment.inner', 'Select inner part of an assignment' },
      ['l='] = { '@assignment.lhs', 'Select left hand side of an assignment' },
      ['r='] = { '@assignment.rhs', 'Select right hand side of an assignment' },
      ['aa'] = { '@parameter.outer', 'Select outer part of a parameter/argument' },
      ['ia'] = { '@parameter.inner', 'Select inner part of a parameter/argument' },
      ['ai'] = { '@conditional.outer', 'Select outer part of a conditional' },
      ['ii'] = { '@conditional.inner', 'Select inner part of a conditional' },
      ['al'] = { '@loop.outer', 'Select outer part of a loop' },
      ['il'] = { '@loop.inner', 'Select inner part of a loop' },
      ['af'] = { '@call.outer', 'Select outer part of a function call' },
      ['if'] = { '@call.inner', 'Select inner part of a function call' },
      ['am'] = { '@function.outer', 'Select outer part of a method/function definition' },
      ['im'] = { '@function.inner', 'Select inner part of a method/function definition' },
      ['ac'] = { '@class.outer', 'Select outer part of a class' },
      ['ic'] = { '@class.inner', 'Select inner part of a class' },
    }
    for lhs, mapping in pairs(select_mappings) do
      local query, desc = mapping[1], mapping[2]
      vim.keymap.set({ 'x', 'o' }, lhs, function()
        select.select_textobject(query, 'textobjects')
      end, { desc = desc })
    end

    local swap = require 'nvim-treesitter-textobjects.swap'
    vim.keymap.set('n', '<leader>na', function()
      swap.swap_next '@parameter.inner'
    end, { desc = 'Swap parameter/argument with next' })
    vim.keymap.set('n', '<leader>nm', function()
      swap.swap_next '@function.outer'
    end, { desc = 'Swap function with next' })
    vim.keymap.set('n', '<leader>pa', function()
      swap.swap_previous '@parameter.inner'
    end, { desc = 'Swap parameter/argument with previous' })
    vim.keymap.set('n', '<leader>pm', function()
      swap.swap_previous '@function.outer'
    end, { desc = 'Swap function with previous' })

    local move = require 'nvim-treesitter-textobjects.move'
    local move_mappings = {
      goto_next_start = {
        [']f'] = { '@call.outer', 'textobjects', 'Next function call start' },
        [']m'] = { '@function.outer', 'textobjects', 'Next method/function def start' },
        [']c'] = { '@class.outer', 'textobjects', 'Next class start' },
        [']i'] = { '@conditional.outer', 'textobjects', 'Next conditional start' },
        [']l'] = { '@loop.outer', 'textobjects', 'Next loop start' },
        [']s'] = { '@local.scope', 'locals', 'Next scope' },
        [']z'] = { '@fold', 'folds', 'Next fold' },
      },
      goto_next_end = {
        [']F'] = { '@call.outer', 'textobjects', 'Next function call end' },
        [']M'] = { '@function.outer', 'textobjects', 'Next method/function def end' },
        [']C'] = { '@class.outer', 'textobjects', 'Next class end' },
        [']I'] = { '@conditional.outer', 'textobjects', 'Next conditional end' },
        [']L'] = { '@loop.outer', 'textobjects', 'Next loop end' },
      },
      goto_previous_start = {
        ['[f'] = { '@call.outer', 'textobjects', 'Prev function call start' },
        ['[m'] = { '@function.outer', 'textobjects', 'Prev method/function def start' },
        ['[c'] = { '@class.outer', 'textobjects', 'Prev class start' },
        ['[i'] = { '@conditional.outer', 'textobjects', 'Prev conditional start' },
        ['[l'] = { '@loop.outer', 'textobjects', 'Prev loop start' },
      },
      goto_previous_end = {
        ['[F'] = { '@call.outer', 'textobjects', 'Prev function call end' },
        ['[M'] = { '@function.outer', 'textobjects', 'Prev method/function def end' },
        ['[C'] = { '@class.outer', 'textobjects', 'Prev class end' },
        ['[I'] = { '@conditional.outer', 'textobjects', 'Prev conditional end' },
        ['[L'] = { '@loop.outer', 'textobjects', 'Prev loop end' },
      },
    }
    for method, mappings in pairs(move_mappings) do
      for lhs, mapping in pairs(mappings) do
        local move_method, query, query_group, desc = method, mapping[1], mapping[2], mapping[3]
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          move[move_method](query, query_group)
        end, { desc = desc })
      end
    end

    -- Add the repeatable move keymaps
    local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

    -- Make builtin f, F, t, T also repeatable
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
