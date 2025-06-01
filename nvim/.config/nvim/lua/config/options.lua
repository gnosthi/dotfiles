-- options.lua - Essential Neovim settings

local opt = vim.opt
local g = vim.g

--------------------------------------------------------------------------------
-- UI Settings
--------------------------------------------------------------------------------
opt.number = true                -- Show line numbers
opt.relativenumber = true        -- Show relative line numbers
opt.showmatch = true             -- Highlight matching brackets
opt.foldmethod = 'marker'        -- Enable folding (default 'foldmarker')
opt.splitright = true            -- Vertical split to the right
opt.splitbelow = true            -- Horizontal split to the bottom
opt.ignorecase = true            -- Ignore case when searching
opt.smartcase = true             -- Do not ignore case with capitals
opt.termguicolors = true         -- Enable 24-bit RGB colors
opt.laststatus = 3               -- Global statusline
opt.showmode = false             -- Don't show mode since we have a statusline
opt.cmdheight = 1                -- Height of the command bar
opt.incsearch = true             -- Makes search act like search in modern browsers
opt.showmatch = true             -- Show matching brackets when text indicator is over them
opt.cursorline = true            -- Highlight the current line
opt.cursorlineopt = "number"     -- Only highlight the number of the cursorline
opt.signcolumn = "yes"           -- Always show the signcolumn, otherwise it would shift the text
opt.scrolloff = 8                -- Minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 8            -- Minimal number of screen columns to keep to the left and right
opt.guifont = "monospace:h11"    -- The font used in graphical neovim applications
opt.title = true                 -- Set the title of the window to the value of the titlestring
opt.titlestring = "nvim - %t"    -- What the title of the window will be set to
opt.fillchars = { eob = " " }    -- Don't show tilde on empty lines

--------------------------------------------------------------------------------
-- Tabs, indent
--------------------------------------------------------------------------------
opt.expandtab = true             -- Use spaces instead of tabs
opt.shiftwidth = 4               -- Shift 4 spaces when tab
opt.tabstop = 4                  -- 1 tab == 4 spaces
opt.smartindent = true           -- Autoindent new lines
opt.wrap = false                 -- Don't wrap lines by default
opt.linebreak = true             -- Wrap on word boundary if wrap is enabled

--------------------------------------------------------------------------------
-- Search settings
--------------------------------------------------------------------------------
opt.hlsearch = true              -- Highlight all matches on previous search pattern
opt.ignorecase = true            -- Ignore case in search patterns
opt.smartcase = true             -- Override ignorecase if search contains uppercase
opt.inccommand = "split"         -- Preview substitutions live, as you type

--------------------------------------------------------------------------------
-- Performance settings
--------------------------------------------------------------------------------
opt.hidden = true                -- Enable background buffers
opt.history = 500                -- Remember more commands and search history
opt.undolevels = 1000            -- Maximum number of changes that can be undone
opt.updatetime = 250             -- Faster completion (default is 4000ms)
opt.timeoutlen = 300             -- By default timeoutlen is 1000 ms
opt.ttimeoutlen = 10             -- Time in milliseconds to wait for a key code sequence to complete
opt.synmaxcol = 240              -- Only highlight the first 240 columns

--------------------------------------------------------------------------------
-- Split behavior
--------------------------------------------------------------------------------
opt.splitbelow = true            -- Put new windows below current
opt.splitright = true            -- Put new windows right of current

--------------------------------------------------------------------------------
-- Backup and undo settings
--------------------------------------------------------------------------------
opt.backup = false               -- Don't make a backup before overwriting a file
opt.writebackup = false          -- No backup before overwriting a file
opt.swapfile = false             -- Don't create a swapfile
opt.undofile = true              -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undodir"  -- Set undo directory

--------------------------------------------------------------------------------
-- Clipboard settings
--------------------------------------------------------------------------------
opt.clipboard = "unnamedplus"    -- Sync with system clipboard

--------------------------------------------------------------------------------
-- Misc settings
--------------------------------------------------------------------------------
opt.fileencoding = "utf-8"         -- File encoding
opt.completeopt = {"menuone", "noselect"}  -- Better completion
opt.mouse = "a"                    -- Enable mouse support
opt.confirm = true                 -- Confirm before closing unsaved buffer
opt.backspace = "indent,eol,start" -- Allow backspace on indent, end of line or insert mode start position
opt.shortmess:append "c"           -- Don't show completion messages
opt.iskeyword:append("-")          -- Treat dash as part of words
opt.formatoptions = "jcroqlnt"     -- tcqj

--------------------------------------------------------------------------------
-- Disable builtin plugins we don't use
--------------------------------------------------------------------------------
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

return {}

