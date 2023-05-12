-- @title nvim/init.vim
-- @author Yoshiya Ito
-- @version 8.0.0

-- packer config
vim.cmd[[packadd packer.nvim]]
require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim' } -- package manager
  use { 'neovim/nvim-lspconfig' } -- LSP
  use { 'williamboman/mason.nvim' } -- LSP package manager
  use { 'williamboman/mason-lspconfig.nvim' } -- LSP config bridge
  use { 'jose-elias-alvarez/null-ls.nvim' } -- LSP improve
  use { 'glepnir/lspsaga.nvim', branch = 'main' } -- LSP UI/Code outline
  use { 'hrsh7th/nvim-cmp' } -- completion LSP
  use { 'hrsh7th/cmp-nvim-lsp' } -- completion LSP source
  use { 'hrsh7th/cmp-buffer' } -- completion LSP file buffer
  use { 'hrsh7th/cmp-path' } -- completion LSP file path
  use { 'hrsh7th/cmp-cmdline' } -- completion LSP vim command
  use { 'onsails/lspkind.nvim' } -- completion with Icon
  use { 'L3MON4D3/LuaSnip' } -- code snippet
  use { 'saadparwaiz1/cmp_luasnip' } -- code snippet to cmp
  use { 'rafamadriz/friendly-snippets' } -- snippet set
  use { 'nvim-treesitter/nvim-treesitter', run = function() require('nvim-treesitter.install').update({ with_sync = true }) end, } -- syntax hilight
  use { 'kyazdani42/nvim-web-devicons' } -- icon
  use { 'kyazdani42/nvim-tree.lua' } -- filer
  use { 'rcarriga/nvim-notify', requires = {{"MunifTanjim/nui.nvim"}} } -- notification
  use { 'folke/trouble.nvim' } -- trouble shooting
  use({ "folke/noice.nvim" }) -- message and cmd
  use { 'michaelb/sniprun', run = 'bash install.sh' } -- quick code run
  use { 'nvim-lualine/lualine.nvim' } -- status line
  use { 'nvim-telescope/telescope.nvim', tag='0.1.0', requires = {{'nvim-lua/plenary.nvim'}} } -- fuzzy omni search
  use { 'lukas-reineke/indent-blankline.nvim' } -- show indent
  use { 'norcalli/nvim-colorizer.lua' } -- color code visibility
  use { 'editorconfig/editorconfig-vim' } -- editor config
  use { 'prettier/vim-prettier', run = 'yarn install --frozen-lockfile --production' } -- ts code formatter
  use { 'EdenEast/nightfox.nvim' } -- color_schema
  use { 'rebelot/kanagawa.nvim' } -- color_scheme
  use { 'folke/tokyonight.nvim', branch= 'main' } -- colorscheme
  -- Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' } " go
end)

-- vim grobal config
vim.o.title = true -- show title
-- vim.o.number = true -- show number
vim.o.writebackup = false -- nobackup
vim.o.swapfile = false -- noswapfile
vim.o.display = 'uhex'  -- show hex
vim.o.signcolumn = "yes" --signcolumn
vim.o.expandtab = true -- tab to space
vim.o.smarttab = true -- smarttab
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.cindent = true      -- c interigent indent
vim.o.autoindent = true   -- autoindent !neovim default
vim.o.smartindent = true  -- smart indent system
vim.o.showmatch = true    -- show ()[]{}match
vim.o.smartcase = true    -- search smart case
vim.wo.wrap = false       -- nowrap
vim.o.foldenable = false
vim.opt.mouse = ""
vim.opt.clipboard:append{'unnamedplus'} -- clipboad
vim.opt.fillchars = {     -- vert sign
  vert = " ",
  eob = " ",
}

-- remove traling white space
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//ge]],
})

-- key remap
vim.keymap.set('i', 'jj', '<esc>', { silent = true})
vim.keymap.set('n', 's', '<Nop>', { silent = true})
vim.keymap.set('n', 'ss', ':<C-u>sp<CR>', { silent = true})
vim.keymap.set('n', 'sv', ':<C-u>vs<CR>', { silent = true})
vim.keymap.set('n', 'sq', ':<C-u>q<CR>', { silent = true})
vim.keymap.set('n', 'sj', '<C-w>j', { silent = true})
vim.keymap.set('n', 'sk', '<C-w>k',{ silent = true})
vim.keymap.set('n', 'sl', '<C-w>l', { silent = true})
vim.keymap.set('n', 'sh', '<C-w>h', { silent = true})
vim.keymap.set('n', 'sJ', '<C-w>J', { silent = true})
vim.keymap.set('n', 'sK', '<C-w>K', { silent = true})
vim.keymap.set('n', 'sL', '<C-w>L', { silent = true})
vim.keymap.set('n', 'sH', '<C-w>H', { silent = true})

-- tab keymap
vim.keymap.set('n', 'tt', ':<C-u>tabnew<CR><C-u>NvimTreeOpen<CR>', { silent = true })
vim.keymap.set('n', 'tl', 'gt', { silent = true })
vim.keymap.set('n', 'th', 'gT', { silent = true })

-- color config
vim.o.termguicolors = true
require("tokyonight").setup({
  style = "storm",
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})
vim.cmd[[colorscheme tokyonight]]
-- vim.cmd[[colorscheme kanagawa]]
-- vim.cmd[[colorscheme molokai]]
-- vim.cmd[[colorscheme nightfox]]

-- Icon/Sign Settings
for type, icon in pairs({Error = " ", Warn = " ", Hint = " ", Info = " "}) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- callback
local on_attach = function(client, bufnr)
  -- auto formatter
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go" },
    callback = function()
      vim.lsp.buf.formatting_sync()
    end,
  })

  -- auto import (go)
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go" },
    callback = function()
      local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
      params.context = {only = {"source.organizeImports"}}

      local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 100)
      for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
          if r.edit then
            vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
          else
            vim.lsp.buf.execute_command(r.command)
          end
        end
      end
    end,
  })
  -- lspsagaのcode outline初回起動
  -- vim.api.nvim_exec("Lspsaga outline", false)
end

-- mason
require('mason').setup({
  automatic_installation = true,
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- mason lsp config
require('mason-lspconfig').setup_handlers({function(server_name)
  require('lspconfig')[server_name].setup {
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  }
end })

-- null-ls config
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- require("null-ls").setup({
--     sources = {
--         require("null-ls").builtins.formatting.stylua,
--         require("null-ls").builtins.diagnostics.eslint,
--         require("null-ls").builtins.completion.spell,
--         require("null-ls").builtins.formatting.gofumpt,
--         require("null-ls").builtins.formatting.goimports,
--     },
--     on_attach = function(client, bufnr)
--         if client.supports_method("textDocument/formatting") then
--             vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 group = augroup,
--                 buffer = bufnr,
--                 callback = function()
--                    vim.lsp.buf.formatting_sync()
--                 end,
--             })
--         end
--     end,
-- })

-- lspsaga config
require 'lspsaga'.setup({
  max_preview_lines = 50,
  finder = {
    keys = {
      vsplit = 'v',
      split = 's',
    },
  },
  outline = {
    win_position = "right",
    win_width = 30,
  },
  ui = {
    border = 'rounded',
    winblend = 0,
  }
})
vim.keymap.set("n", "cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
vim.keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>", { silent = true })
vim.keymap.set("n", "gs", "<Cmd>Lspsaga signature_help<CR>", { silent = true })
vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
vim.keymap.set("n", "<C-O>", "<cmd>Lspsaga outline<CR>" , { silent = true})

-- completion config / comp, luanip, lspkind
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'
require 'luasnip.loaders.from_vscode'.lazy_load()
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      maxwidth = 50,
    })
  }
}
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- nvim-treesitter config
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  ignore_install = { "phpdoc", "tree-sitter-phpdoc" },
  highlight = {
    enable = true,
    disable = {"html", "css"},
  },
  indent = {
    enable = true,
  },
}

-- nvim-tree config
local function open_nvim_tree()
  require("nvim-tree.api").tree.toggle({ focus = false })
end
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { silent = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 'o', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', '<C-s>', api.node.run.system, opts('Run System'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 's', '', { buffer = bufnr })
  vim.keymap.del('n', 's', { buffer = bufnr })
  vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
end

require'nvim-tree'.setup {
  open_on_tab = true,
  renderer = {
    highlight_opened_files = "all",
  },
  on_attach = on_attach,
  view = {
    width = 20,
    side = "left",
  },
}

-- lualine config
require('lualine').setup {
  options = {
    theme = 'tokyonight',
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {
      {
        'filename',
        symbols = {
          readonly = '[]'
        }
      }
    },
  },
  tabline = {
    lualine_a = {'buffers'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_z = {'tabs'}
  }
}

-- trouble config
vim.keymap.set("n", "TT", "<cmd>TroubleToggle<cr>", { silent = true })
require("trouble").setup {
  padding = false,
  height = 6,
  icons = true,
  -- auto_open = true, -- automatically open the list when you have diagnostics
  -- auto_close = true, -- automatically close the list when you have no diagnostics
}


-- sniprun config
vim.keymap.set("v", "f", "<plug>SnipRun<cr>", { silent = true })
require'sniprun'.setup({
  display = {"NvimNotify"},
})
require("notify").setup({
  background_colour =  "#000000",
})

-- telescope config
vim.keymap.set("n", "ff", "<cmd>Telescope find_files<cr>", { silent = true })
vim.keymap.set("n", "fg", "<cmd>Telescope live_grep<cr>", { silent = true })
vim.keymap.set("n", "fb", "<cmd>Telescope buffers<cr>", { silent = true })
vim.keymap.set("n", "fh", "<cmd>Telescope help_tags<cr>", { silent = true })
require('telescope').setup{}

-- utitily config
-- color code visible, indent visible
require'colorizer'.setup()
require("indent_blankline").setup {
  show_current_context = true,
  show_current_context_start = true,
}

-- vim-go and prettier
vim.g['prettier#autoformat'] = 1
vim.g['prettier#autoformat_require_pragma'] = 0
vim.g['prettier#config#print_width'] = 120
