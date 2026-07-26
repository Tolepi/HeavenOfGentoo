-- =============================================================
-- HEAVEN OF GENTOO - MONOLITHIC NEOVIM CONFIG (LAZY.NVIM)
-- Location: ~/.config/nvim/init.lua
-- =============================================================

-- --- 1. OPCIONES BÁSICAS DEL EDITOR ---
local opt = vim.opt

opt.number = true            -- Números de línea
opt.relativenumber = true    -- Números relativos para saltos rápidos
opt.termguicolors = true     -- Colores de 24 bits
opt.showmode = false         -- Ocultar el texto de modo por defecto
opt.wrap = false             -- Desactivar ajuste automático de línea
opt.cursorline = true        -- Resaltar la línea actual
opt.scrolloff = 8            -- Mantener espacio al hacer scroll
opt.tabstop = 4              -- Indentación a 4 espacios
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.fillchars = { eob = " " } -- Elimina las tildes (~) al final del búfer

-- Leader key (Espacio)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- --- 2. INSTALACIÓN AUTOMÁTICA DE LAZY.NVIM ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- --- 3. DECLARACIÓN DE PLUGINS CON LAZY.NVIM ---
require("lazy").setup({
  -- Telescope (Buscador difuso)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar archivos" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Buscar texto" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
          },
        },
      })
    end,
  },

  -- Neo-tree (Explorador de archivos lateral)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorador de archivos" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "single",
        filesystem = {
          filtered_items = { visible = true, hide_dotfiles = false },
        },
        default_component_configs = {
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
          },
        },
      })
    end,
  },

  -- Lualine (Statusline minimalista)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local theme = {
        normal = {
          a = { fg = "#101216", bg = "#9d7cd8", gui = "bold" },
          b = { fg = "#c0caf5", bg = "#161920" },
          c = { fg = "#565f89", bg = "#101216" },
        },
        insert  = { a = { fg = "#101216", bg = "#9d7cd8", gui = "bold" } },
        visual  = { a = { fg = "#101216", bg = "#565f89", gui = "bold" } },
        replace = { a = { fg = "#101216", bg = "#9d7cd8", gui = "bold" } },
        inactive = {
          a = { fg = "#565f89", bg = "#101216" },
          b = { fg = "#565f89", bg = "#101216" },
          c = { fg = "#565f89", bg = "#101216" },
        },
      }

      require("lualine").setup({
        options = {
          theme = theme,
          component_separators = "",
          section_separators = "",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "filename" },
          lualine_c = {},
          lualine_x = { "diagnostics" },
          lualine_y = { "filetype" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  -- Autocompletado (cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        window = {
          completion = cmp.config.window.bordered({
            border = "single",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
          }),
          documentation = cmp.config.window.bordered({
            border = "single",
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}, {
  ui = {
    border = "single",
    icons = {
      cmd = "⌘", config = "🛠", event = "📅", ft = "📂",
      init = "⚙", keys = "🗝", plugin = "🔌", runtime = "💻",
      source = "📄", start = "🚀", task = "📌", lazy = "💤 ",
    },
  },
})

-- --- 4. TEMA MONOCROMÁTICO PURA INYECCIÓN (GENTOO PURPLE) ---
local c = {
  bg       = "#101216", -- Fondo ultra oscuro
  bg_alt   = "#161920", -- Contenedores / Paneles
  border   = "#1f2335", -- Bordes y marcas
  muted    = "#565f89", -- Comentarios / Elementos inactivos
  text     = "#c0caf5", -- Texto claro
  gentoo   = "#9d7cd8", -- Morado Gentoo
}

local hl = {
  -- Interfaz general
  Normal       = { fg = c.text, bg = c.bg },
  NormalFloat  = { fg = c.text, bg = c.bg_alt },
  FloatBorder  = { fg = c.border, bg = c.bg_alt },
  CursorLine   = { bg = c.bg_alt },
  CursorLineNr = { fg = c.gentoo, bold = true },
  LineNr       = { fg = c.muted },
  WinSeparator = { fg = c.border, bg = c.bg },
  Pmenu        = { fg = c.text, bg = c.bg_alt },
  PmenuSel     = { fg = c.bg, bg = c.gentoo, bold = true },
  
  -- Sintaxis
  Comment      = { fg = c.muted, italic = true },
  Constant     = { fg = c.gentoo },
  String       = { fg = c.gentoo },
  Number       = { fg = c.gentoo },
  Function     = { fg = c.gentoo, bold = true },
  Statement    = { fg = c.gentoo },
  Keyword      = { fg = c.gentoo, bold = true },
  Operator     = { fg = c.muted },
  Type         = { fg = c.gentoo },
  
  -- Telescope Highlights
  TelescopeBorder         = { fg = c.border, bg = c.bg_alt },
  TelescopePromptBorder   = { fg = c.border, bg = c.bg_alt },
  TelescopePromptNormal   = { fg = c.text, bg = c.bg_alt },
  TelescopePromptPrefix   = { fg = c.gentoo },
  TelescopeSelection      = { fg = c.bg, bg = c.gentoo, bold = true },
  TelescopeSelectionCaret = { fg = c.bg },
  
  -- Neo-tree Highlights
  NeoTreeNormal           = { fg = c.text, bg = c.bg_alt },
  NeoTreeNormalNC         = { fg = c.text, bg = c.bg_alt },
  NeoTreeRootName         = { fg = c.gentoo, bold = true },
  NeoTreeDirectoryName    = { fg = c.text },
  NeoTreeDirectoryIcon    = { fg = c.gentoo },
  NeoTreeGitModified      = { fg = c.gentoo },
  NeoTreeGitUntracked     = { fg = c.muted },
  
  -- Diagnósticos y LSP (Sin verdes/rojos)
  DiagnosticError         = { fg = c.muted },
  DiagnosticWarn          = { fg = c.muted },
  DiagnosticInfo          = { fg = c.gentoo },
  DiagnosticHint          = { fg = c.muted },
}

-- Forzar resaltados en el API
for group, styles in pairs(hl) do
  vim.api.nvim_set_hl(0, group, styles)
end
