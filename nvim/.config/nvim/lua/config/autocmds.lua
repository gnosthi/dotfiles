-- autocmds.lua - Neovim autocommands configuration
-- A collection of autocommands to enhance the Neovim experience

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Utility function to create autocommand groups
local function create_augroup(name, autocmds)
  local group = augroup(name, { clear = true })
  for _, opts in ipairs(autocmds) do
    opts.group = group
    local event = opts.event  -- Extract the event
    opts.event = nil          -- Remove the event key from the options table
    autocmd(event, opts)      -- Call autocmd with event and cleaned options table
  end
  return group
end

-- ┌─────────────────────────────────────────────────────────────────┐
-- │ General Utilities                                                │
-- └─────────────────────────────────────────────────────────────────┘

-- Highlight on yank
create_augroup("YankHighlight", {
  {
    event = "TextYankPost",
    pattern = "*",
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
    end,
    desc = "Highlight text on yank",
  },
})

-- Auto-restore cursor position
create_augroup("RestoreCursor", {
  {
    event = "BufReadPost",
    pattern = "*",
    callback = function()
      local line = vim.fn.line
      if line("'\"") > 1 and line("'\"") <= line("$") then
        vim.cmd('normal! g`"')
      end
    end,
    desc = "Restore cursor position when opening a file",
  },
})

-- Check if file changed when its window is focused, more eager than 'autoread'
create_augroup("CheckTime", {
  {
    event = { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
    pattern = "*",
    command = "if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif",
    desc = "Check if file changed when window is focused",
  },
})

-- ┌─────────────────────────────────────────────────────────────────┐
-- │ File Operations                                                  │
-- └─────────────────────────────────────────────────────────────────┘

-- Auto create directories when saving a file
create_augroup("AutoCreateDirectory", {
  {
    event = "BufWritePre",
    pattern = "*",
    callback = function(event)
      if event.match:match("^%w%w+://") then
        return
      end
      local file = vim.loop.fs_realpath(event.match) or event.match
      local dir = vim.fn.fnamemodify(file, ":h")
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, "p")
        vim.notify("Created directory: " .. dir, vim.log.levels.INFO)
      end
    end,
    desc = "Create directory if it doesn't exist when saving a file",
  },
})

-- Remove trailing whitespace on save
create_augroup("TrimWhitespace", {
  {
    event = "BufWritePre",
    pattern = "*",
    callback = function()
      local curpos = vim.fn.getpos(".")
      vim.cmd([[keeppatterns %s/\s\+$//e]])
      vim.fn.setpos(".", curpos)
    end,
    desc = "Remove trailing whitespace when saving a file",
  },
})

-- Auto-formatting on save (applies when formatters are available)
create_augroup("AutoFormat", {
  {
    event = "BufWritePre",
    pattern = "*",
    callback = function()
		  local bufnr = vim.api.nvim_get_current_buf()
		  local active = vim.lsp.get_active_clients({ bufnr = bufnr })
		  local has_lsp = false
		  for _, client in ipairs(active) do
		    if client.supports_method("textDocument/formatting") then
		      has_lsp = true
		      break
    		end
		  end

		  if not has_lsp then
    		vim.cmd("silent! undojoin")
		    vim.cmd("silent! normal! gg=G")
		    vim.cmd("normal! `.")
		  end
	end,
  },
})

-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Terminal Settings                                                │
-- └─────────────────────────────────────────────────────────────────┘

create_augroup("TerminalSettings", {
  {
    event = "TermOpen",
    pattern = "*",
    callback = function()
      -- Start terminal in insert mode, with no line numbers, relative line numbers, or sign column
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.signcolumn = "no"
      vim.opt_local.cursorline = false
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.spell = false
      vim.cmd("startinsert")
    end,
    desc = "Configure terminal options and start in insert mode",
  },
  {
    event = "BufEnter",
    pattern = "term://*",
    command = "startinsert",
    desc = "Automatically enter insert mode when entering a terminal",
  },
  {
    event = "BufLeave",
    pattern = "term://*",
    command = "stopinsert",
    desc = "Automatically exit insert mode when leaving a terminal",
  },
})

-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Filetype-Specific Settings                                       │
-- └─────────────────────────────────────────────────────────────────┘

-- Set indentation for specific filetypes
create_augroup("FileTypeSettings", {
  {
    event = "FileType",
    pattern = { "lua", "json", "jsonc", "yaml", "html", "css", "scss", "xml" },
    command = "setlocal tabstop=2 shiftwidth=2 expandtab",
    desc = "Set indentation to 2 spaces for various filetypes",
  },
  {
    event = "FileType",
    pattern = { "python", "rust", "go" },
    command = "setlocal tabstop=4 shiftwidth=4 expandtab",
    desc = "Set indentation to 4 spaces for Python, Rust, and Go",
  },
  {
    event = "FileType",
    pattern = "markdown",
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
      vim.opt_local.conceallevel = 0
    end,
    desc = "Configure Markdown settings",
  },
})

-- Auto-reload configuration when saving Neovim config files
create_augroup("ReloadConfig", {
  {
    event = "BufWritePost",
    pattern = { "*/nvim/*.lua", "*/nvim/*/*.lua" },
    callback = function(event)
      -- Don't reload plugins folder on save to avoid errors
      if event.match:match("plugins") then
        return
      end

      vim.notify("Reloading Neovim configuration...", vim.log.levels.INFO)
      vim.cmd("source " .. event.match)
    end,
    desc = "Auto-reload Neovim configuration when saving Lua files",
  },
})

-- Return autocmds module
return {
  create_augroup = create_augroup,
}

