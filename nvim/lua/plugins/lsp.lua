return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'stevearc/conform.nvim',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'j-hui/fidget.nvim',
  },

  config = function()
    require('conform').setup {
      formatters_by_ft = {},
    }

    local cmp = require 'cmp'
    local cmp_lsp = require 'cmp_nvim_lsp'
    local capabilities = vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require('fidget').setup {}
    require('mason').setup()
    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'gopls',
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              local opts = { buffer = bufnr }
              vim.keymap.set('n', 'gd', function()
                vim.lsp.buf.definition()
              end, opts)
              vim.keymap.set('n', 'K', function()
                vim.lsp.buf.hover()
              end, opts)
              vim.keymap.set('n', '<leader>vws', function()
                vim.lsp.buf.workspace_symbol()
              end, opts)
              vim.keymap.set('n', '<leader>vd', function()
                vim.diagnostic.open_float()
              end, opts)
              vim.keymap.set('n', '<leader>vca', function()
                vim.lsp.buf.code_action()
              end, opts)
              vim.keymap.set('n', '<leader>vrr', function()
                vim.lsp.buf.references()
              end, opts)
              vim.keymap.set('n', '<leader>vrn', function()
                vim.lsp.buf.rename()
              end, opts)
              vim.keymap.set('i', '<C-h>', function()
                vim.lsp.buf.signature_help()
              end, opts)
              vim.keymap.set('n', '[d', function()
                vim.diagnostic.goto_next()
              end, opts)
              vim.keymap.set('n', ']d', function()
                vim.diagnostic.goto_prev()
              end, opts)
            end,
          }
        end,

        zls = function()
          local lspconfig = require 'lspconfig'
          lspconfig.zls.setup {
            root_dir = lspconfig.util.root_pattern('.git', 'build.zig', 'zls.json'),
            settings = {
              zls = {
                enable_inlay_hints = true,
                enable_snippets = true,
                warn_style = true,
              },
            },
          }
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,

        ['lua_ls'] = function()
          local lspconfig = require 'lspconfig'
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = 'Lua 5.1' },
                diagnostics = {
                  globals = { 'bit', 'vim', 'it', 'describe', 'before_each', 'after_each' },
                },
              },
            },
            on_attach = function(client, bufnr)
              local opts = { buffer = bufnr }
              vim.keymap.set('n', 'gd', function()
                vim.lsp.buf.definition()
              end, opts)
              vim.keymap.set('n', 'K', function()
                vim.lsp.buf.hover()
              end, opts)
              vim.keymap.set('n', '<leader>vws', function()
                vim.lsp.buf.workspace_symbol()
              end, opts)
              vim.keymap.set('n', '<leader>vd', function()
                vim.diagnostic.open_float()
              end, opts)
              vim.keymap.set('n', '<leader>vca', function()
                vim.lsp.buf.code_action()
              end, opts)
              vim.keymap.set('n', '<leader>vrr', function()
                vim.lsp.buf.references()
              end, opts)
              vim.keymap.set('n', '<leader>vrn', function()
                vim.lsp.buf.rename()
              end, opts)
              vim.keymap.set('i', '<C-h>', function()
                vim.lsp.buf.signature_help()
              end, opts)
              vim.keymap.set('n', '[d', function()
                vim.diagnostic.goto_next()
              end, opts)
              vim.keymap.set('n', ']d', function()
                vim.diagnostic.goto_prev()
              end, opts)
            end,
          }
        end,
      },
    }

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup {
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete(),
      },
      sources = cmp.config.sources({
        { name = 'copilot', group_index = 2 },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
      }, {
        { name = 'buffer' },
      }),
    }

    vim.diagnostic.config {
      float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
      },
    }
  end,
}
