-- plugins/init.lua - Plugin configuration with lazy.nvim
-- This file sets up lazy.nvim and imports plugins from modular spec files

-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Lazy.nvim Configuration                                          │
-- └─────────────────────────────────────────────────────────────────┘

-- Configuration table for lazy.nvim
local lazy_config = {
  root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
  defaults = {
    lazy = true, -- plugins are loaded on demand by default
    version = false, -- prefer using latest git commit
  },
  install = {
    -- install missing plugins on startup
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "catppuccin", "tokyonight", "habamax" },
  },
  ui = {
    -- a number <1 is a percentage, >1 is a fixed size
    size = { width = 0.8, height = 0.8 },
    -- border to use for the floating window
    border = "rounded",
    icons = {
      cmd = " ",
      config = " ",
      event = " ",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = " ",
      task = " ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    -- check for updates on startup
    check_on_start = true,
    -- automatically update plugins that have no breaking changes
    auto_update = false,
    -- check for plugin updates once a day
    frequency = 86400, -- 24 hours
  },
  change_detection = {
    -- automatically check for config file changes and reload
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  readme = {
    -- read plugin documentation
    enabled = true,
    root = vim.fn.stdpath("state") .. "/lazy/readme",
  },
}

-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Plugin Imports                                                   │
-- └─────────────────────────────────────────────────────────────────┘

-- Core plugins that don't fit in other categories
local core_plugins = {
  -- Dependency for many plugins
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Better UI components
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Better notification management
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- Useful utility functions
  {
    "echasnovski/mini.nvim",
    lazy = true,
    version = false,
  },

  -- Neovim API extensions
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "BufNew" },
    opts = {},
  },

  -- Better quickfix window
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "%d+L, %d+B",
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
}

-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Plugin Specs Array                                               │
-- └─────────────────────────────────────────────────────────────────┘

-- Combine all plugin sources
local plugins = {}

-- Add core plugins
vim.list_extend(plugins, core_plugins)

-- Import all plugin modules and add them to the plugins table
local plugin_modules = {
  "plugins.themes",
  "plugins.ui",
  "plugins.coding",
  "plugins.lsp",
  "plugins.completion",
  "plugins.tools",
}

-- Load each module if it exists
for _, module_name in ipairs(plugin_modules) do
  local ok, module = pcall(require, module_name)
  if ok and module then
    if type(module) == "table" then
      vim.list_extend(plugins, module)
    else
      vim.notify("Module " .. module_name .. " did not return a table", vim.log.levels.WARN)
    end
  end
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Initialize Lazy.nvim                                             │
-- └─────────────────────────────────────────────────────────────────┘

-- Setup function (called from init.lua)
local function setup()
  -- Initialize lazy with our configuration
  require("lazy").setup(plugins, lazy_config)
end

return {
  setup = setup,
}

