require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

local lspconfig = require('lspconfig')
local conf = require("metals.config")
local log = require("metals.log")

-- -- lsp diagnostic lines
-- require("lsp_lines").setup()
-- vim.diagnostic.config({
--   virtual_text = false,
--   virtual_lines = true
-- })

local metals_client_settings = {
  showImplicitArguments = false,
  showImplicitConversionsAndClasses = false,
  superMethodLensesEnabled = false,
  showInferredType = true,
  enableSemanticHighlighting = false,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl",
    "akka.stream.javadsl",
  },
  -- serverVersion = local_config.config.metals_server_version,
  serverVersion = "1.1.1-SNAPSHOT",
  serverProperties = {
    "-Xmx4g",
    "-Xss10m",
    "-XX:+CrashOnOutOfMemoryError",
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
local inline_capabilities = {
  workspace = {
    inlayHint = {
      refreshSupport = true
    },
  },
  textDocument = {
    inlayHint = {
      resolveSupport = {
        properties = {
          "tooltip",
          "textEdits",
          "label.tooltip",
          "label.location",
          "label.command"
        }
      },
      dynamicRegistration =  true
    }
  }
}


Metals_config.capabilities = vim.tbl_deep_extend("force", completion_capabilities, {})

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

require("lsp-inlayhints").setup({

})

vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
vim.api.nvim_create_autocmd("LspAttach", {
	group = "LspAttach_inlayhints",
	callback = function(args)
		if not (args.data and args.data.client_id) then
			return
		end

		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		require("lsp-inlayhints").on_attach(client, bufnr)
	end,
})

Metals_config.on_attach = function(client, bufnr)
  require("lsp-inlayhints").on_attach(client, bufnr, true)
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
}

-- HASKELL -------------------------------------------------------------
lspconfig.hls.setup {
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
  capabilities = completion_capabilities 
}

-- CSS -----------------------------------------------------------------

lspconfig.cssls.setup {
  capabilities = completion_capabilities,
}

lspconfig.rust_analyzer.setup {
  capabilities = completion_capabilities,
}

-- Language Tool
lspconfig.ltex.setup{}

-- Nix
lspconfig.rnix.setup{}

return LSP
