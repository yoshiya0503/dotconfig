-- @title nvim/init.vim
-- @author Yoshiya Ito
-- @version 11.0.0

-- lazy config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { "neovim/nvim-lspconfig" },                                        -- LSP
  { "williamboman/mason.nvim" },                                                            -- LSP package manager
  { "williamboman/mason-lspconfig.nvim" },                                                  -- LSP config bridge
  { "hrsh7th/nvim-cmp" },                                                                   -- completion LSP
  { "hrsh7th/cmp-nvim-lsp" },                                                               -- completion LSP source
  { "hrsh7th/cmp-buffer" },                                                                 -- completion LSP file buffer
  { "hrsh7th/cmp-path" },                                                                   -- completion LSP file path
  { "hrsh7th/cmp-cmdline" },                                                                -- completion LSP vim command
  { "onsails/lspkind.nvim" },                                                               -- completion with Icon
  { "L3MON4D3/LuaSnip" },                                                                   -- code snippet
  { "saadparwaiz1/cmp_luasnip" },                                                           -- code snippet to cmp
  { "rafamadriz/friendly-snippets" },                                                       -- snippet set
  { "nvim-treesitter/nvim-treesitter",    build = ":TSUpdate" },                            -- syntax hilight
  { "kyazdani42/nvim-web-devicons" },                                                       -- icon
  { "kyazdani42/nvim-tree.lua" },                                                           -- filer
  { 'akinsho/bufferline.nvim' },                                                            -- tab buffer integration
  { 'Bekaboo/dropbar.nvim' },                                                               -- breadcrumbs
  { "lukas-reineke/indent-blankline.nvim" },                                                -- show indent
  { "nvim-lualine/lualine.nvim" },                                                          -- status line
  { "rcarriga/nvim-notify",               dependencies = { { "MunifTanjim/nui.nvim" } } },  -- notification
  { "folke/trouble.nvim", },                                                                -- trouble shooting
  { "folke/noice.nvim" },                                                                   -- message and cmd
  { "michaelb/sniprun",                   build = "sh install.sh" },                        -- quick code run
  { "nvim-telescope/telescope.nvim",      dependencies = { { "nvim-lua/plenary.nvim" } } }, -- fuzzy omni search
  { "lewis6991/gitsigns.nvim" },                                                            -- gitsigns
  { "norcalli/nvim-colorizer.lua" },                                                        -- color code visibility
  { "windwp/nvim-autopairs", },                                                             -- surrounding pairs
  { "folke/tokyonight.nvim" },                                                              -- colorscheme
  { "akinsho/toggleterm.nvim" },                                                            -- terminal
})

-- vim grobal config
vim.o.termguicolors = true
vim.o.signcolumn = "yes" -- signcolumn
vim.o.expandtab = true   -- tab to space
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.cindent = true     -- c interigent indent
vim.o.smartindent = true -- smart indent system
vim.o.showmatch = true   -- show ()[]{}match
vim.o.smartcase = true   -- search smart case
vim.o.swapfile = false   -- no swapfile
vim.o.laststatus = 3

-- vim.opt.mouse = ""
vim.opt.clipboard:append { "unnamedplus" }
-- signs
vim.opt.fillchars = {
  horiz     = " ",
  horizup   = " ",
  horizdown = " ",
  vert      = " ",
  vertleft  = " ",
  vertright = " ",
  verthoriz = " ",
  eob       = " ",
}

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
})

-- key remap
vim.keymap.set("i", "jj", "<esc>", { silent = true })
vim.keymap.set("n", "s", "<Nop>", { silent = true })
vim.keymap.set("n", "ss", ":<C-u>sp<CR>", { silent = true })
vim.keymap.set("n", "sv", ":<C-u>vs<CR>", { silent = true })
vim.keymap.set("n", "sq", ":<C-u>q<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "tt", ":<C-u>tabnew<CR><C-u>NvimTreeOpen<CR>", { silent = true })
vim.keymap.set("n", "tl", "gt", { silent = true })
vim.keymap.set("n", "th", "gT", { silent = true })

-- color config
require("tokyonight").setup({
  style = "storm",
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})
vim.cmd [[colorscheme tokyonight]]

-- callback
-- vim.api.nvim_create_autocmd({ "BufWritePre", "LspAttach" }, {
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.cmd([[%s/\s\+$//ge]]) -- remove trailing white space
    vim.lsp.buf.format()
    vim.lsp.buf.code_action { context = { only = { 'source.fixAll' } }, apply = true }
    -- vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
  end,
})

-- mason
require("mason").setup({
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
require("mason-lspconfig").setup({ automatic_enable = true })
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", { capabilities = capabilities })

-- dropbar config
vim.ui.select = require('dropbar.utils.menu').select
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { silent = true })
vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, { silent = true })
vim.keymap.set('n', 'gk', vim.diagnostic.open_float, { silent = true })
vim.keymap.set('n', 'gf', function() vim.lsp.buf.code_action({ only = { "fixAll" } }) end, { silent = true })
vim.keymap.set('n', 'gi', function() vim.lsp.buf.code_action({ only = { "organizeImports" } }) end, { silent = true })

-- completion config / comp, luanip, lspkind
local cmp = require "cmp"
local luasnip = require "luasnip"
local lspkind = require "lspkind"
require "luasnip.loaders.from_vscode".lazy_load()
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
  formatting = {
    format = lspkind.cmp_format({
      maxwidth = 50,
    })
  }
}
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- nvim-treesitter config
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
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
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
  vim.keymap.set("n", "o", api.node.open.horizontal, opts("Open: Horizontal Split"))
  vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
  vim.keymap.set("n", "<C-s>", api.node.run.system, opts("Run System"))
  vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "s", "", { buffer = bufnr })
  vim.keymap.del("n", "s", { buffer = bufnr })
end

require("nvim-tree").setup {
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

-- buffer line
require("bufferline").setup {
  options = {
    mode = "tabs", -- set to "tabs" to only show tabpages instead
  },
  highlights = {
    fill = { bg = 'none' },
    tab = { bg = 'none' },
    background = { bg = 'none' },
    buffer_visible = { bg = 'none' },
    buffer_selected = { bg = 'none' }
  }
}

-- lualine config
require("evil_line")

-- trouble config
require("trouble").setup {
  win = {
    wo = {
      fillchars = ""
    }
  },
  modes = {
    diagnostics = {
      auto_open = false,
      win = {
        size = 7,
      },
    },
  },
}
vim.keymap.set("n", "TT", "<cmd>Trouble diagnostics toggle<cr>", { silent = true })
vim.keymap.set("n", "TO", "<cmd>Trouble symbols toggle focus=false<cr>", { silent = true })
vim.keymap.set("n", "TD", "<cmd>Trouble lsp toggle focus=false win.position=<cr>", { silent = true })

-- noice config
require("noice").setup({
  routes = {
    {
      filter = {
        event = "notify",
        find = "available",
      },
      opts = { skip = true },
    },
    {
      view = "mini",
      filter = {
        event = "msg_show",
        find = "書込み",
      },
    },
  },
  cmdline = {
    format = {
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
    },
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    progress = {
      enabled = false
    },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    -- bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true,       -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true,        -- add a border to hover docs and signature help
  },
})

-- toggleterm config
require("toggleterm").setup {
  direction = 'float',
  float_opts = {
    border = 'curved'
  }
}

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-t>', "<cmd>ToggleTerm<cr>", opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
vim.keymap.set('n', '<C-t>', "<cmd>ToggleTerm<cr>", opts)

-- sniprun config
require("sniprun").setup({ display = { "NvimNotify" }, })
vim.keymap.set("v", "f", "<plug>SnipRun<cr>", { silent = true })

-- telescope config
require("telescope").setup {}
vim.keymap.set("n", "ff", "<cmd>Telescope find_files<cr>", { silent = true })
vim.keymap.set("n", "fg", "<cmd>Telescope live_grep<cr>", { silent = true })
vim.keymap.set("n", "fb", "<cmd>Telescope buffers<cr>", { silent = true })
vim.keymap.set("n", "fh", "<cmd>Telescope help_tags<cr>", { silent = true })

-- utitily config
-- color code visible, indent visible
require("colorizer").setup()
require("nvim-autopairs").setup()
require("ibl").setup()
require("notify").setup({ timeout = 100 })
require("gitsigns").setup()
