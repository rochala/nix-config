require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

local conf = require("metals.config")
local log = require("metals.log")

local SymbolKind = vim.lsp.protocol.SymbolKind

require'lsp-lens'.setup({
  enable = true,
  include_declaration = false,      -- Reference include declaration
  sections = {                      -- Enable / Disable specific request, formatter example looks 'Format Requests'
    definitions = true,
    references = true,
    implements = true,
    git_authors = true,
  },
  -- Target Symbol Kinds to show lens information
  target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface },
  -- Symbol Kinds that may have target symbol kinds as children
  wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
})

-- vim.lsp.set_log_level("debug")

local metals_client_settings = {
  showImplicitArguments = false,
  showImplicitConversionsAndClasses = false,
  superMethodLensesEnabled = true,
  showInferredType = "minimal",
  enableSemanticHighlighting = false,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl",
    "akka.stream.javadsl",
  },
  -- serverVersion = local_config.config.metals_server_version,
  serverVersion = "latest.snapshot",
  telemetryLevel = "full",
  serverProperties = {
    "-Xmx4g",
    "-Xss10m",
    "-XX:+CrashOnOutOfMemoryError",
    "-Dmetals.loglevel=debug",
    "-Dmetals.enable-best-effort=true"
    -- "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:5055"
  },
}

-- use path in case of local "SNAPSHOT" versions, else don't set it and use coursiers to resolve it.

-- METALS -------------------------------------------------------------
Metals_config = require("metals").bare_config()

LSP = {}
LSP.update_metals_setting = function(key, value)
  local message = string.format("Setting %s is now %s changed from %s", key, value, metals_client_settings[key])
  metals_client_settings[key] = value
  log.info_and_show(message)

  vim.lsp.buf_notify(0, "workspace/didChangeConfiguration", { settings = { metals = metals_client_settings} })

end

Metals_config.settings = metals_client_settings
Metals_config.init_options.statusBarProvider = "on"

local completion_capabilities =  require("cmp_nvim_lsp").default_capabilities()

Metals_config.capabilities = completion_capabilities


local dap = require("dap")

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "RunOrTest",
    metals = {
      runType = "runOrTestFile",
      --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

local methods = vim.lsp.protocol.Methods
local default_on_attach = function(client, bufnr)
    if client.supports_method(methods.textDocument_documentHighlight) then
        local under_cursor_highlights_group =
            vim.api.nvim_create_augroup('rochala/cursor_highlights', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave', 'BufEnter' }, {
            group = under_cursor_highlights_group,
            desc = 'Highlight references under the cursor',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
            group = under_cursor_highlights_group,
            desc = 'Clear highlight references',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    print(client.supports_method(methods.textDocument_inlayHint))
    if client.supports_method(methods.textDocument_inlayHint) then
        local inlay_hints_group = vim.api.nvim_create_augroup('rochala/toggle_inlay_hints', { clear = false })

        -- Initial inlay hint display.
        -- Idk why but without the delay inlay hints aren't displayed at the very start.
        vim.defer_fn(function()
            local mode = vim.api.nvim_get_mode().mode
            vim.lsp.inlay_hint.enable(mode == 'n' or mode == 'v')
        end, 500)

        vim.api.nvim_create_autocmd('InsertEnter', {
            group = inlay_hints_group,
            desc = 'Disable inlay hints',
            buffer = bufnr,
            callback = function()
                vim.lsp.inlay_hint.enable(false)
            end,
        })
        vim.api.nvim_create_autocmd('InsertLeave', {
            group = inlay_hints_group,
            desc = 'Enable inlay hints',
            buffer = bufnr,
            callback = function()
                vim.lsp.inlay_hint.enable(true)
            end,
        })
    end
end

local diagnostics_icons = {
    ERROR = '',
    WARN = '',
    HINT = '',
    INFO = '',
}

-- Define the diagnostic signs.
for severity, icon in pairs(diagnostics_icons) do
    local hl = 'DiagnosticSign' .. severity:sub(1, 1) .. severity:sub(2):lower()
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

-- Diagnostic configuration.
vim.diagnostic.config {
    virtual_text = {
        prefix = '',
        spacing = 2,
        format = function(diagnostic)
            local icon = diagnostics_icons[vim.diagnostic.severity[diagnostic.severity]]
            local message = vim.split(diagnostic.message, '\n')[1]
            return string.format('%s %s ', icon, message)
        end,
    },
    float = {
        border = 'rounded',
        source = 'if_many',
        -- Show severity icons as prefixes.
        prefix = function(diag)
            local level = vim.diagnostic.severity[diag.severity]
            local prefix = string.format(' %s ', diagnostics_icons[level])
            return prefix, 'Diagnostic' .. level:gsub('^%l', string.upper)
        end,
    },
    -- Disable signs in the gutter.
    signs = false,
}

-- -- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
-- local show_handler = vim.diagnostic.handlers.virtual_text.show
-- assert(show_handler)
-- local hide_handler = vim.diagnostic.handlers.virtual_text.hide
-- vim.diagnostic.handlers.virtual_text = {
--     show = function(ns, bufnr, diagnostics, opts)
--         table.sort(diagnostics, function(diag1, diag2)
--             return diag1.severity > diag2.severity
--         end)
--         return show_handler(ns, bufnr, diagnostics, opts)
--     end,
--     hide = hide_handler,
-- }

Metals_config.on_attach = function(client, bufnr)
  -- vim.lsp.inlay_hint.enable(bufnr)
  default_on_attach(client, bufnr)
  require("metals").setup_dap()
end

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java", "mill" },
  callback = function()
    require("metals").initialize_or_attach(Metals_config)
  end,
  group = nvim_metals_group,
})

-- Set .mill files to be recognized as Scala
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.mill",
  callback = function()
    vim.bo.filetype = "scala"
  end,
})

-- LUA -------------------------------------------------------------

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

vim.lsp.config('lua_ls', {
  on_attach = default_on_attach,
  capabilities = completion_capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      hint = {
        enable = true
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      completion = {
        callSnippet = "Replace"
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
})

vim.lsp.enable('lua_ls')

-- CSS -----------------------------------------------------------------

vim.lsp.enable('cssls')
vim.lsp.config('cssls', {
  capabilities = completion_capabilities,
})

vim.lsp.config('rust_analyzer', {
  capabilities = completion_capabilities,
  on_attach = default_on_attach,
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
})

vim.lsp.enable('rust_analyzer')

-- Language Tool
vim.lsp.enable('ltex')

-- Nix
vim.lsp.enable('rnix')

-- Smithy
vim.lsp.enable('smithy_ls')

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.smithy",
  callback = function()
    vim.bo.filetype = "smithy"
  end,
})

return LSP
