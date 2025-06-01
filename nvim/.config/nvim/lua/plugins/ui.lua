-- UI-related plugins
return {
  -- Status notifications
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    priority = 1000,
    config = function()
      require("incline").setup()
    end,
  },

  -- Snacks - Modern UI Components for Neovim
  {
    "folke/snacks.nvim",
    event = "VeryLazy",
    opts = {
      -- Enable all features
      enable = {
        alert = true,       -- Enable alerts
        browse = true,      -- Enable file browsing
        dashboard = true,   -- Enable dashboard
        icons = true,       -- Enable icons
        input = true,       -- Enable input UI
        picker = true,      -- Enable picker
        zen = true,        -- Enable zen mode
      },

      -- Alert configuration
      alert = {
        timeout = 3000,
        max_width = 80,
        max_height = 20,
        border = "rounded",
        icons = {
          error = " ",
          warn = " ",
          info = " ",
          success = " ",
        },
      },

      -- Input configuration
      input = {
        border = "rounded",
        win_options = {
          winblend = 10,
        },
      },

      -- Browse configuration
      browse = {
        border = "rounded",
        win_options = {
          winblend = 10,
        },
      },

      -- Dashboard configuration
      dashboard = {
        border = "rounded",
        win_options = {
          winblend = 10,
        },
      },

      -- Zen mode configuration
      zen = {
        -- Zen mode options
        plugins = {
          gitsigns = true,
          tmux = true,
          kitty = {
            enabled = true,
            font = "+2",
          },
        },
      },
    },
    -- Additional configuration in setup
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Create global notification functions
      _G.notify = {
        info = function(msg, title)
          require("snacks").alert({
            title = title,
            message = msg,
            level = "info",
          })
        end,
        warn = function(msg, title)
          require("snacks").alert({
            title = title,
            message = msg,
            level = "warn",
          })
        end,
        error = function(msg, title)
          require("snacks").alert({
            title = title,
            message = msg,
            level = "error",
          })
        end,
        success = function(msg, title)
          require("snacks").alert({
            title = title,
            message = msg,
            level = "success",
          })
        end,
      }

      -- Add keymaps for zen mode
      vim.keymap.set("n", "<leader>z", function()
        require("snacks.zen").toggle()
      end, { desc = "Toggle Zen Mode" })

      -- Add keymap for dashboard
      vim.keymap.set("n", "<leader>d", function()
        require("snacks.dashboard").open()
      end, { desc = "Open Dashboard" })
    end,
  },
}

