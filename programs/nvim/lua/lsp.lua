require('lspconfig')

local lsp_status = require('lsp-status')
lsp_status.register_progress()

-- METALS -------------------------------------------------------------
Metals_config = require("metals").bare_config{}

Metals_config.settings = {
  showImplicitArguments = true,
  showImplicitConversionsAndClasses = true,
  superMethodLensesEnabled = false,
  showInferredType = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl",
    "akka.stream.javadsl",
  },
  -- serverVersion = "latest.snapshot",
  serverProperties = {
    "-Dmetals.verbose",
    "-Xmx4g",
    "-Xss10m",
    "-XX:+CrashOnOutOfMemoryError",
  },
  serverVersion = "0.11.6-SNAPSHOT",
}

-- local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })

local capabilities = vim.lsp.protocol.make_client_capabilities()

Metals_config.init_options.statusBarProvider = "on"
Metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
Metals_config.on_attach = function(client, bufnr)

  vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]])
  vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
  require "lsp_signature".on_attach({
    hint_enable = false,
    handler_opts = {
      border = "single"
    },
  }, bufnr)
  -- require("metals").setup_dap()
end

-- LUA -------------------------------------------------------------

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  settings = {
    commands = {
      Format = {
        function()
          require("stylua-nvim").format_file()
        end,
      },
    },
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
