-- @title nvim/init.vim
-- @author Yoshiya Ito
-- @version 10.0.0

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
  { "glepnir/lspsaga.nvim" },                                                               -- LSP UI/Code outline
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
  { "rcarriga/nvim-notify",               dependencies = { { "MunifTanjim/nui.nvim" } } },  -- notification
  { "folke/trouble.nvim" },                                                                 -- trouble shooting
  { "folke/noice.nvim" },                                                                   -- message and cmd
  { "michaelb/sniprun",                   build = "sh install.sh" },                        -- quick code run
  { "nvim-lualine/lualine.nvim" },                                                          -- status line
  { "nvim-telescope/telescope.nvim",      dependencies = { { "nvim-lua/plenary.nvim" } } }, -- fuzzy omni search
  { "lukas-reineke/indent-blankline.nvim" },                                                -- show indent
  { "norcalli/nvim-colorizer.lua" },                                                        -- color code visibility
  { "editorconfig/editorconfig-vim" },                                                      -- editor config
  { "folke/tokyonight.nvim" },                                                              -- colorscheme
})

-- vim grobal config
vim.o.termguicolors = true
vim.o.signcolumn = "yes" -- signcolumn
vim.o.expandtab = true   -- tab to space
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.cindent = true                           -- c interigent indent
vim.o.smartindent = true                       -- smart indent system
vim.o.showmatch = true                         -- show ()[]{}match
vim.o.smartcase = true                         -- search smart case
vim.opt.fillchars = { vert = " ", eob = " ", } -- vert sign
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

-- remove traling white space
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//ge]],
})

-- key remap
vim.keymap.set("i", "jj", "<esc>", { silent = true })
vim.keymap.set("n", "s", "<Nop>", { silent = true })
vim.keymap.set("n", "ss", ":<C-u>sp<CR>", { silent = true })
vim.keymap.set("n", "sv", ":<C-u>vs<CR>", { silent = true })
vim.keymap.set("n", "sq", ":<C-u>q<CR>", { silent = true })
vim.keymap.set("n", "sj", "<C-w>j", { silent = true })
vim.keymap.set("n", "sk", "<C-w>k", { silent = true })
vim.keymap.set("n", "sl", "<C-w>l", { silent = true })
vim.keymap.set("n", "sh", "<C-w>h", { silent = true })
vim.keymap.set("n", "sJ", "<C-w>J", { silent = true })
vim.keymap.set("n", "sK", "<C-w>K", { silent = true })
vim.keymap.set("n", "sL", "<C-w>L", { silent = true })
vim.keymap.set("n", "sH", "<C-w>H", { silent = true })

-- tab keymap
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
  on_highlights = function(hl, colors)
    hl.CursorLine = {
      fg = colors.yellow
    }
  end
})
vim.cmd [[colorscheme tokyonight]]

-- callback
-- vim.api.nvim_create_autocmd({ "BufWritePre", "LspAttach" }, {
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    vim.lsp.buf.format()
    local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
    params.context = { only = { "source.organizeImports" } }

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
require("mason-lspconfig").setup_handlers({ function(server_name)
  require("lspconfig")[server_name].setup {
    capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
      Lua = { diagnostics = { globals = { 'vim' } } }
    }
  }
end })

-- lspsaga config
require("lspsaga").setup({
  max_preview_lines = 50,
  finder = {
    keys = {
      vsplit = "v",
      split = "s",
    },
  },
  outline = {
    win_position = "right",
    win_width = 30,
  },
  ui = {
    border = "rounded",
    winblend = 0,
  }
})
vim.keymap.set("n", "cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })
vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
-- vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { silent = true })
vim.keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>", { silent = true })
vim.keymap.set("n", "gs", "<Cmd>Lspsaga signature_help<CR>", { silent = true })
-- vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })
-- vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })
vim.keymap.set("n", "<C-O>", "<cmd>Lspsaga outline<CR>", { silent = true })

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

-- nvim-treesitter config
require("nvim-treesitter.configs").setup {
  highlight = {
    enable = true,
    disable = { "html", "css" },
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
}

-- lualine config
require("lualine").setup {
  sections = {
    lualine_c = {
      {
        "filename",
        symbols = {
          readonly = "[]"
        }
      }
    },
  },
}

-- trouble config
require("trouble").setup {
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

-- noice config
require("noice").setup({
  cmdline = {
    format = {
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
    }
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
    lsp_doc_border = false,       -- add a border to hover docs and signature help
  },
})

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
require("ibl").setup()
require("notify").setup({
  timeout = 100,
})
