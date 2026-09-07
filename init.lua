vim.g.mapleader        = " "
vim.g.localleader      = " "

--### OPTIONS ###--
vim.g.c_no_curly_error = 1
vim.opt.foldlevelstart = 99

vim.o.number           = true -- Show line numbers in a column.
vim.o.relativenumber   = true
vim.opt.wrap           = false

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase       = true
vim.o.smartcase        = true

vim.o.cursorline       = false -- Highlight the line where the cursor is on.
vim.o.scrolloff        = 5     -- Keep this many screen lines above/below the cursor.
vim.o.list             = true  -- Show <tab> and trailing spaces.

-- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
vim.o.confirm          = true

vim.o.undofile         = true  -- Persistent undo across sessions
vim.o.signcolumn       = 'yes' -- Always show sign column (prevents layout shift from LSP/gitsigns)
vim.o.splitright       = true  -- Vertical splits open to the right
vim.o.splitbelow       = true  -- Horizontal splits open below
vim.o.tabstop          = 4     -- Tab width
vim.o.shiftwidth       = 4     -- Indent width
vim.o.expandtab        = true  -- Spaces instead of tabs
vim.o.termguicolors    = true  -- True colour support (needed by most themes/plugins)

vim.cmd.colorscheme('habamax')

vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<CR>')

vim.cmd('iabbrev cmain #include <stdio.h><CR><CR>int main(void){}')

--### KEYMAPS ###--

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<C-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<C-l>', '<C-w>l')

-- AUTOCOMMANDS (EVENT HANDLERS)

-- Highlight when yanking (copying) text.
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    callback = function()
        vim.hl.on_yank()
    end,
})

--### USER COMMANDS: DEFINE CUSTOM COMMANDS ###--

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
    local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
    local filename = vim.api.nvim_buf_get_name(0)
    print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

-- PLUGINS

-- Install third-party plugins via "vim.pack.add()".
vim.pack.add({
    -- Fuzzy picker
    'https://github.com/ibhagwan/fzf-lua',
    -- mini-nivm
    'https://github.com/nvim-mini/mini.completion',
    'https://github.com/nvim-mini/mini.statusline',
    'https://github.com/nvim-mini/mini.icons',
    'https://github.com/nvim-mini/mini.pairs',
    'https://github.com/nvim-mini/mini.surround',
    -- Enhanced quickfix/loclist
    'https://github.com/stevearc/quicker.nvim',
    -- Git integration
    'https://github.com/lewis6991/gitsigns.nvim',
    --treesitter
    'https://github.com/nvim-treesitter/nvim-treesitter',
    --oil
    'https://github.com/stevearc/oil.nvim',
    --marks
    'https://github.com/chentoast/marks.nvim',

    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/folke/trouble.nvim',
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/OXY2DEV/markview.nvim',
    'https://github.com/iamcco/markdown-preview.nvim',
})

--fzf options and keybinds
local fzf = require('fzf-lua')
vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fd', fzf.diagnostics_workspace, { desc = 'Diagnostics' })

require('fzf-lua').setup { fzf_colors = true }
require('mini.completion').setup {}
require('nvim-web-devicons').setup {}
require('markview').setup {}
require('mini.statusline').setup {}
require('mini.icons').setup {}
require('mini.pairs').setup {}
require('mini.surround').setup {
    mappings = {
        add = 'sa',        -- Add surrounding in Normal and Visual modes
        delete = 'sd',     -- Delete surrounding
        find = 'sf',       -- Find surrounding (to the right)
        find_left = 'sF',  -- Find surrounding (to the left)
        highlight = 'sh',  -- Highlight surrounding
        replace = 'sr',    -- Replace surrounding

        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
    },
}
require('quicker').setup {}
require('marks').setup {}
require('gitsigns').setup {}

-- Configuration (optional but useful)
vim.g.mkdp_auto_close = 0       -- don't auto-close preview when leaving the buffer
vim.g.mkdp_theme = 'dark'       -- 'dark' or 'light'
vim.g.mkdp_browser = ''         -- empty means don't auto-open
vim.g.mkdp_echo_preview_url = 1 -- echo the URL when starting

-- Install the parsers you want (idempotent — only installs missing ones)
require('nvim-treesitter').install({
    'c', 'lua', 'python', 'markdown', 'markdown_inline',
    -- add others as needed: 'bash', 'json', 'toml', 'vim', 'vimdoc', etc.
})

-- Actually turn highlighting on when a file opens
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'lua', 'python', 'markdown' },
    callback = function(args)
        vim.treesitter.start()
        -- Optional: treesitter-based folding
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        -- Optional: treesitter-based indent
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

require('oil').setup {
    view_options = {
        sort = {
            { "name", "asc" }, -- then by name
            { "type", "asc" }, -- keep directories grouped
        },
    },
}
require('trouble').setup {}
local harpoon = require("harpoon")
harpoon:setup()

--lsp
-- Keymaps that activate only when an LSP attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP keymaps',
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = desc })
        end
        map('gd', vim.lsp.buf.definition, 'Go to definition')
        map('gD', vim.lsp.buf.declaration, 'Go to declaration')
        map('gr', vim.lsp.buf.references, 'Go to references')
        map('gi', vim.lsp.buf.implementation, 'Go to implementation')
        map('K', vim.lsp.buf.hover, 'Hover docs')
        map('<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
        map('<leader>lf', function() vim.lsp.buf.format { async = true } end, 'Format buffer')
        map('<leader>ld', vim.diagnostic.open_float, 'Line diagnostics')
        map('[d', vim.diagnostic.goto_prev, 'Prev diagnostic')
        map(']d', vim.diagnostic.goto_next, 'Next diagnostic')
    end,
})

vim.diagnostic.config {
    virtual_text  = true,
    signs         = true,
    underline     = true,
    severity_sort = true,
    float         = { border = 'rounded', source = true },
}

vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = { checkThirdParty = false },
        },
    },
})

vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', '.git' },
})

vim.lsp.config('clangd', {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp' },
    root_markers = { 'compile_commands.json', '.git' },
})

vim.lsp.config('marksman', {
    cmd = { 'marksman', 'server' },
    filetypes = { 'markdown', 'markdown.mdx' },
    root_markers = { '.marksman.toml', '.git' },
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('marksman')
vim.lsp.enable('pyright')
vim.lsp.enable('clangd')

--### keymaps ###--
vim.keymap.set('n', '<leader>e', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})


vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add" })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

-- Jumplist
vim.keymap.set('n', '<C-o>', '<C-o>zz')
vim.keymap.set('n', '<C-i>', '<C-i>zz')

-- Search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
vim.keymap.set('n', '*', '*zz')
vim.keymap.set('n', '#', '#zz')
vim.keymap.set('n', 'g*', 'g*zz')
vim.keymap.set('n', 'g#', 'g#zz')

-- Half-page scrolling (bonus — keeps cursor centered while scrolling)
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Marks (need an expr mapping because ' and ` consume the next char)
vim.keymap.set('n', "'", function()
    return "'" .. vim.fn.getcharstr() .. 'zz'
end, { expr = true })

vim.keymap.set('n', '`', function()
    return '`' .. vim.fn.getcharstr() .. 'zz'
end, { expr = true })
