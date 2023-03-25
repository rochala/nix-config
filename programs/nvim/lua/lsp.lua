require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

local lspconfig = require('lspconfig')

local lsp_status = require('lsp-status')
lsp_status.register_progress()

-- -- lsp diagnostic lines
-- require("lsp_lines").setup()
-- vim.diagnostic.config({
--   virtual_text = false,
--   virtual_lines = true
-- })

-- METALS -------------------------------------------------------------
Metals_config = require("metals").bare_config{}

Metals_config.settings = {
  showImplicitArguments = true,
  showImplicitConversionsAndClasses = true,
  superMethodLensesEnabled = false,
  showInferredType = true,
  enableSemanticHighlighting = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl",
    "akka.stream.javadsl",
  },
  serverVersion = "latest.snapshot",
  serverProperties = {
    "-Dmetals.verbose=true",
    "-Xmx4g",
    "-Xss10m",
    "-XX:+CrashOnOutOfMemoryError",
  },
}

Metals_config.init_options.statusBarProvider = "on"
Metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Metals_config.on_attach = function(_, _)
--   vim.cmd([[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]])
--   vim.cmd([[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]])
-- end


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

Metals_config.on_attach = function(client, bufnr)
  require("metals").setup_dap()
end

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(Metals_config)
  end,
  group = nvim_metals_group,
})

-- LUA -------------------------------------------------------------

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
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
}

-- HASKELL -------------------------------------------------------------
lspconfig.hls.setup {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  capabilities = capabilities
}

-- CSS -----------------------------------------------------------------

lspconfig.cssls.setup {
  capabilities = capabilities,
}

-- Language Tool
lspconfig.ltex.setup{}

-- Nix
lspconfig.rnix.setup{}
