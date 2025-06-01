-- keymaps.lua - Key mappings for Neovim

local M = {}

--------------------------------------------------------------------------------
-- Helper function for mapping
--------------------------------------------------------------------------------
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

--------------------------------------------------------------------------------
-- Basic editor operations
--------------------------------------------------------------------------------

-- Save and quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit without saving" })
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

-- Resize window using <Alt> arrow keys
map("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move text up and down
map("n", "<A-j>", ":m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })

-- Close buffer without closing window
map("n", "<leader>c", "<cmd>bp<bar>sp<bar>bn<bar>bd<cr>", { desc = "Close buffer" })

-- Clear search with <esc>
map("n", "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

--------------------------------------------------------------------------------
-- Visual mode improvements
--------------------------------------------------------------------------------

-- Stay in indent mode
map("v", "<", "<gv", { desc = "Indent left and stay in visual mode" })
map("v", ">", ">gv", { desc = "Indent right and stay in visual mode" })

-- Don't copy the replaced text after pasting in visual mode
map("v", "p", '"_dP', { desc = "Paste without copying replaced text" })

--------------------------------------------------------------------------------
-- Quality of life improvements
--------------------------------------------------------------------------------

-- Toggle relative line numbers
map("n", "<leader>ur", "<cmd>set relativenumber!<cr>", { desc = "Toggle relative line numbers" })

-- Toggle wrap
map("n", "<leader>uw", "<cmd>set wrap!<cr>", { desc = "Toggle line wrap" })

-- Center cursor when moving half page up/down
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Center search results
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Better join - keep cursor position
map("n", "J", "mzJ`z")

-- Toggle between relative/absolute line numbers
map("n", "<leader>ul", "<cmd>lua vim.wo.number = true; vim.wo.relativenumber = not vim.wo.relativenumber<cr>", { desc = "Toggle line number mode" })

-- Format document (will be replaced with proper formatter later)
map("n", "<leader>fm", "gg=G<C-o>", { desc = "Format document" })

--------------------------------------------------------------------------------
-- Snacks.nvim notifications
--------------------------------------------------------------------------------

-- Test different types of snacks notifications
map("n", "<leader>tni", function()
  notify.info("This is an info message", "Information")
end, { desc = "Test info notification" })

map("n", "<leader>tnw", function()
  notify.warn("This is a warning message", "Warning")
end, { desc = "Test warning notification" })

map("n", "<leader>tne", function()
  notify.error("This is an error message", "Error")
end, { desc = "Test error notification" })

map("n", "<leader>tns", function()
  notify.success("This is a success message", "Success")
end, { desc = "Test success notification" })

map("n", "<leader>tnd", function()
  notify.debug("This is a debug message", "Debug")
end, { desc = "Test debug notification" })

-- Test notification with animation
map("n", "<leader>tna", function()
  local snacks = require("snacks")
  for i = 1, 3 do
    vim.schedule(function()
      snacks.alert({
        title = "Notification " .. i,
        message = "This is notification number " .. i,
        duration = 3000,
        type = ({ "info", "warning", "success" })[i],
      })
    end)
  end
end, { desc = "Test animated notifications" })

--------------------------------------------------------------------------------
-- Placeholders for future plugins
--------------------------------------------------------------------------------

-- Telescope placeholder (file finding, etc)
map("n", "<leader>ff", "", { desc = "[Placeholder] Find files" })
map("n", "<leader>fg", "", { desc = "[Placeholder] Live grep" })
map("n", "<leader>fb", "", { desc = "[Placeholder] Buffers" })
map("n", "<leader>fh", "", { desc = "[Placeholder] Help tags" })

-- LSP placeholder
map("n", "<leader>lf", "", { desc = "[Placeholder] Format document" })
map("n", "gd", "", { desc = "[Placeholder] Go to definition" })
map("n", "gr", "", { desc = "[Placeholder] Find references" })
map("n", "K", "", { desc = "[Placeholder] Hover Documentation" })

-- Nvim-tree placeholder
map("n", "<leader>e", "", { desc = "[Placeholder] Toggle explorer" })

-- Comment.nvim placeholder
map("n", "<leader>/", "", { desc = "[Placeholder] Comment toggle" })
map("v", "<leader>/", "", { desc = "[Placeholder] Comment toggle selection" })

-- Terminal placeholder
map("n", "<leader>tf", "", { desc = "[Placeholder] Float terminal" })
map("n", "<leader>th", "", { desc = "[Placeholder] Horizontal terminal" })
map("n", "<leader>tv", "", { desc = "[Placeholder] Vertical terminal" })

-- Themery placeholder
map("n", "<leader>ut", "", { desc = "[Placeholder] Theme switcher" })

-- Document the current keymaps for reference in a help window
map("n", "<leader>hk", "<cmd>help key-notation<cr>", { desc = "Help for key notation" })

return M

