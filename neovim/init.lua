-- load a vimrc file
vim.cmd("source $HOME/.config/nvim/vimrc")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- vim.cmd("colorscheme habamax")
--
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
	  {
		  "github/copilot.vim",
		  config = function()
		  end
	  },
	  {
		  "https://github.com/tpope/vim-commentary",
		  config = function()
		  end
	  },
	  {
		  'nvim-telescope/telescope.nvim', tag = '0.1.8',
		  dependencies = { 'nvim-lua/plenary.nvim' }
	  },
	  {
		  'nvim-telescope/telescope-symbols.nvim',
	  },
	  {
		  "CopilotC-Nvim/CopilotChat.nvim",
		  branch = "canary",
		  dependencies = {
			  { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			  { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		  },
		  opts = {
			  debug = true, -- Enable debugging
			  -- See Configuration section for rest
		  },
		  -- See Commands section for default commands if you want to lazy load on them
	  },
	  {
		  "neovim/nvim-lspconfig",
		  config = function()
			  require("lspconfig").pyright.setup({
				  on_attach = on_attach,
				  filetypes = { "python" },
				  autostart = true,
			  })

			  require("lspconfig").clangd.setup({
				  on_attach = on_attach,
				  filetypes = { "c", "cpp" },
				  autostart = true,
				  cmd = { "clangd", "--offset-encoding=utf-16", },
			  })
		  end
	  },
	  
	  {'akinsho/toggleterm.nvim', version = "*", opts = {--[[ things you want to change go here]]}},
	  {'mfussenegger/nvim-dap'},
      { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
	  {'Mofiqul/vscode.nvim'},
	  {'auwsmit/vim-active-numbers'},
	  {'mg979/vim-visual-multi'},
	  {'klen/nvim-config-local'},
	  {'stevearc/oil.nvim'},
	  {'tpope/vim-surround'},
	  {'tpope/vim-fugitive'},
      {"jonboh/nvim-dap-rr", dependencies = {"nvim-dap", "telescope.nvim"}},
      {
          "EthanJWright/vs-tasks.nvim",
          dependencies = {
              "nvim-lua/popup.nvim",
              "nvim-lua/plenary.nvim",
              "nvim-telescope/telescope.nvim",
          },
      },


  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)

local dap = require('dap')
dap.adapters.cpp = {
  type = 'executable',
  command = 'gdb',
  args = {"--interpreter=dap", "--eval-command", "set print pretty on"}
}

local cpptools_path = "/home/hex/.vscode/extensions/ms-vscode.cpptools-1.21.6-linux-x64/debugAdapters/bin/OpenDebugAD7"

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = cpptools_path
}

-- nnoremap <f9> :DapToggleBreakpoint<CR>
-- nnoremap <f5> :DapContinue<CR>
-- nnoremap <S-f5> :DapTerminate<CR>
-- nnoremap <f10> :DapStepOver<CR>
-- nnoremap <f11> :DapStepInto<CR>
-- nnoremap <S-f11> :DapStepOut<CR>
-- nnoremap <leader><f5> :lua require'dapui'.toggle()<CR>
-- set the above keys here in lua
-- dap doesn't have a reverse_step_over function so we have to manually execute "reverse-next" gdb command
-- vim.keymap.set('n', '<s-f10>', function()
--     dap.run({
--         type = "cppdbg",
--         request = "custom",
--         args = { expression = "reverse-next" }
--     })
-- end)

local rr_dap = require('nvim-dap-rr')
rr_dap.setup({

    mappings = {
        continue = "<f4>",
        step_over = "<f10>",
        step_out = "<f8>",
        step_into = "<f11>",
        reverse_continue = "<f4>",
        reverse_step_over = "<s-f10>",
        reverse_step_out = "<s-f8>",
        reverse_step_into = "<s-f11>",
    }
})

dap.configurations.cpp = { rr_dap.get_config() }

-- keep the current line being debugged centered
dap.listeners.after.stackTrace["auto-center"] = function()
  vim.cmd.normal("zz")
end

require("dapui").setup()

-- use vscode colorscheme
vim.cmd("colorscheme vscode")


require("vstask").setup({
  config_dir = ".vscode", -- directory to look for tasks.json and launch.json
  autodetect = { -- auto load scripts
    npm = "on"
  },
  json_parser = 'vim.fn.json.decode',
})

require('config-local').setup {
    -- Default options (optional)

    -- Config file patterns to load (lua supported)
    config_files = { ".nvim.lua", ".nvimrc", ".exrc" },

    -- Where the plugin keeps files data
    hashfile = vim.fn.stdpath("data") .. "/config-local",

    autocommands_create = true, -- Create autocommands (VimEnter, DirectoryChanged)
    commands_create = true,     -- Create commands (ConfigLocalSource, ConfigLocalEdit, ConfigLocalTrust, ConfigLocalIgnore)
    silent = false,             -- Disable plugin messages (Config loaded/ignored)
    lookup_parents = false,     -- Lookup config files in parent directories
}

require("oil").setup({
  default_file_explorer = false,
  keymaps = {
      ["<c-b>"] = function()
          vim.cmd("q")
      end
  }
})


-- lua vim.keymap.set("n", --[[ your key combo --]], function() vim.cmd("vsplit | wincmd l") require("oil").open() end)

 vim.keymap.set("n", "<c-b>", function()
     vim.cmd("vsplit | wincmd l")
     require("oil").open()
end)
