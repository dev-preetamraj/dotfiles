return {
  'shaunsingh/nord.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.nord_contrast = true
    vim.g.nord_borders = false
    vim.g.nord_disable_background = true
    vim.g.nord_italic = false
    vim.g.nord_uniform_diff_background = true
    vim.g.nord_bold = false

    local function apply_typescript_highlights()
      local palette = {
        teal = '#8FBCBB',
        cyan = '#88C0D0',
        blue = '#81A1C1',
        orange = '#D08770',
        yellow = '#EBCB8B',
        green = '#A3BE8C',
        purple = '#B48EAD',
      }

      -- Nord predates the modern Tree-sitter capture names. Add language-specific
      -- colors so TypeScript and TSX remain distinct without changing other files.
      local treesitter = {
        ['@keyword'] = palette.purple,
        ['@keyword.conditional'] = palette.purple,
        ['@keyword.coroutine'] = palette.purple,
        ['@keyword.exception'] = palette.purple,
        ['@keyword.function'] = palette.purple,
        ['@keyword.import'] = palette.purple,
        ['@keyword.modifier'] = palette.purple,
        ['@keyword.repeat'] = palette.purple,
        ['@keyword.return'] = palette.purple,
        ['@keyword.type'] = palette.purple,
        ['@function'] = palette.cyan,
        ['@function.call'] = palette.cyan,
        ['@function.method'] = palette.teal,
        ['@function.method.call'] = palette.teal,
        ['@function.builtin'] = palette.cyan,
        ['@constructor'] = palette.yellow,
        ['@type'] = palette.yellow,
        ['@type.builtin'] = palette.teal,
        ['@module'] = palette.teal,
        ['@module.builtin'] = palette.teal,
        ['@variable.parameter'] = palette.orange,
        ['@variable.member'] = palette.blue,
        ['@constant'] = palette.yellow,
        ['@constant.builtin'] = palette.orange,
        ['@tag'] = palette.yellow,
        ['@tag.builtin'] = palette.purple,
        ['@tag.attribute'] = palette.blue,
        ['@tag.delimiter'] = palette.purple,
        ['@string'] = palette.green,
        ['@number'] = palette.purple,
        ['@boolean'] = palette.orange,
      }
      for capture, color in pairs(treesitter) do
        for _, language in ipairs { 'typescript', 'tsx' } do
          vim.api.nvim_set_hl(0, capture .. '.' .. language, { fg = color })
        end
      end

      -- ts_ls semantic tokens distinguish symbols that syntax alone cannot.
      local semantic = {
        ['class'] = palette.yellow,
        ['enum'] = palette.yellow,
        ['enumMember'] = palette.yellow,
        ['function'] = palette.cyan,
        ['interface'] = palette.yellow,
        ['method'] = palette.teal,
        ['namespace'] = palette.teal,
        ['parameter'] = palette.orange,
        ['property'] = palette.blue,
        ['type'] = palette.yellow,
        ['typeParameter'] = palette.yellow,
      }
      for token, color in pairs(semantic) do
        for _, filetype in ipairs { 'typescript', 'typescriptreact' } do
          vim.api.nvim_set_hl(0, ('@lsp.type.%s.%s'):format(token, filetype), { fg = color })
        end
      end
      for _, filetype in ipairs { 'typescript', 'typescriptreact' } do
        vim.api.nvim_set_hl(0, '@lsp.typemod.variable.readonly.' .. filetype, { fg = palette.yellow })
        vim.api.nvim_set_hl(0, '@lsp.typemod.property.readonly.' .. filetype, { fg = palette.yellow })
      end
    end

    local function apply_python_highlights()
      -- Follow conventional Python coloring while staying within Nord: keywords
      -- are purple, definitions cyan, calls blue, types yellow, parameters and
      -- decorators orange, strings green, and comments muted.
      local palette = {
        foreground = '#D8DEE9',
        comment = '#616E88',
        cyan = '#88C0D0',
        blue = '#81A1C1',
        function_definition = '#8BE9FD',
        function_call = '#82AAFF',
        orange = '#D08770',
        yellow = '#EBCB8B',
        green = '#A3BE8C',
        purple = '#B48EAD',
      }

      local treesitter = {
        ['@keyword'] = palette.purple,
        ['@keyword.conditional'] = palette.purple,
        ['@keyword.coroutine'] = palette.purple,
        ['@keyword.exception'] = palette.purple,
        ['@keyword.function'] = palette.purple,
        ['@keyword.import'] = palette.purple,
        ['@keyword.operator'] = palette.purple,
        ['@keyword.repeat'] = palette.purple,
        ['@keyword.return'] = palette.purple,
        ['@keyword.type'] = palette.purple,
        ['@function'] = palette.function_definition,
        ['@function.call'] = palette.function_call,
        ['@function.method'] = palette.function_definition,
        ['@function.method.call'] = palette.function_call,
        ['@function.builtin'] = palette.cyan,
        ['@constructor'] = palette.yellow,
        ['@type'] = palette.yellow,
        ['@type.builtin'] = palette.yellow,
        ['@type.definition'] = palette.yellow,
        ['@module'] = palette.cyan,
        ['@module.builtin'] = palette.cyan,
        ['@variable'] = palette.foreground,
        ['@variable.builtin'] = palette.orange,
        ['@variable.parameter'] = palette.orange,
        ['@variable.member'] = palette.blue,
        ['@attribute'] = palette.orange,
        ['@attribute.builtin'] = palette.orange,
        ['@constant'] = palette.yellow,
        ['@constant.builtin'] = palette.orange,
        ['@boolean'] = palette.orange,
        ['@string'] = palette.green,
        ['@string.documentation'] = palette.green,
        ['@number'] = palette.orange,
        ['@number.float'] = palette.orange,
        ['@operator'] = palette.cyan,
        ['@comment'] = palette.comment,
      }
      for capture, color in pairs(treesitter) do
        vim.api.nvim_set_hl(0, capture .. '.python', { fg = color })
      end
      for _, capture in ipairs { '@function', '@function.method' } do
        vim.api.nvim_set_hl(0, capture .. '.python', { fg = palette.function_definition, bold = true })
      end

      -- These take effect when a Python server supplies semantic tokens and
      -- complement (rather than replace) the Tree-sitter syntax colors.
      local semantic = {
        ['class'] = palette.yellow,
        ['function'] = palette.function_definition,
        ['method'] = palette.function_call,
        ['namespace'] = palette.cyan,
        ['parameter'] = palette.orange,
        ['property'] = palette.blue,
        ['type'] = palette.yellow,
        ['typeParameter'] = palette.yellow,
      }
      for token, color in pairs(semantic) do
        vim.api.nvim_set_hl(0, ('@lsp.type.%s.python'):format(token), { fg = color })
      end
      vim.api.nvim_set_hl(0, '@lsp.type.function.python', { fg = palette.function_definition, bold = true })
    end

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('nord-language-highlights', { clear = true }),
      pattern = 'nord',
      callback = function()
        apply_typescript_highlights()
        apply_python_highlights()
      end,
    })

    require('nord').set()
    apply_typescript_highlights()
    apply_python_highlights()

    -- Toggle background transparency
    local bg_transparent = true

    local toggle_transparency = function()
      bg_transparent = not bg_transparent
      vim.g.nord_disable_background = bg_transparent
      vim.cmd [[colorscheme nord]]
    end

    vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })
  end,
}
