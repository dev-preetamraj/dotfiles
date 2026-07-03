return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'mason-org/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP
    {
      'j-hui/fidget.nvim',
      opts = {
        notification = {
          window = {
            winblend = 0,
          },
        },
      },
    },

    -- Provides extra capabilities for nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    -- This autocommand sets up buffer-local keymaps and settings when an LSP attaches.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Keymaps for LSP actions
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'v' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Highlight references under the cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Toggle inlay hints
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Set up client capabilities with nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Define server configurations
    local servers = {
      ts_ls = {},
      ruff = {},
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              -- IMPORTANT: This tells jedi to use the python from your activated venv
              jedi = {
                environment = vim.fn.exepath 'python3' or vim.fn.exepath 'python',
              },
              -- Using ruff for linting is highly recommended
              ruff = {
                enabled = true,
              },
              -- Disable other linters if you are using ruff
              pycodestyle = { enabled = false },
              pyflakes = { enabled = false },
              pylint = { enabled = false },
            },
          },
        },
      },
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      emmet_ls = {
        filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact' },
      },
      cssls = {},
      tailwindcss = {},
      dockerls = {},
      sqlls = {},
      terraformls = {},
      jsonls = {},
      yamlls = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            runtime = { version = 'LuaJIT' },
            workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file('', true) },
            diagnostics = { globals = { 'vim' }, disable = { 'missing-fields' } },
            format = { enable = false },
          },
        },
      },
    }

    -- Ensure servers are installed by mason-tool-installer
    local ensure_installed = vim.tbl_keys(servers)
    vim.list_extend(ensure_installed, { 'stylua' })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Bridge Mason and nvim-lspconfig
    require('mason-lspconfig').setup()

    -- Set up servers with nvim-lspconfig
    local lspconfig = require 'lspconfig'
    for server_name, config in pairs(servers) do
      config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
      lspconfig[server_name].setup(config)
    end
  end,
}
