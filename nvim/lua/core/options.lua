-- vim.g.{name}: global,全局变量
-- vim.b.{name}: buffer,缓冲区变量
-- vim.w.{name}: window,窗口变量
-- vim.o.{name}: 全局属性,我们可以利用options来记忆
-- vim.bo.{option}: 缓冲区属性,我们可以利用buffer-option来记忆
-- vim.wo.{option}: 窗口属性,我们可以利用window-option来记忆
-- This file is automatically loaded by plugins.core
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- utf-8
vim.g.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

-- hjkl 移动时光标周围保留8行,这边我不需要,我使用zz,zt,zb来控制窗口
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8

-- 使用相对行号
vim.wo.number = true
vim.wo.relativenumber = true

-- 高亮所在行
vim.wo.cursorline = true

-- 显示左侧图标指示列
vim.wo.signcolumn = "yes"

-- 右侧参考线,超过表示代码太长了,可以考虑换行
-- vim.wo.colorcolumn = "90"

-- 缩进2个空格等于一个tab
vim.o.tabstop = 2
vim.bo.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftround = true

-- >> <<时移动的长度
vim.o.shiftwidth = 2
vim.bo.shiftwidth = 2

-- 空格代替tab
vim.o.expandtab = true
vim.bo.expandtab = true

-- 新行对齐当前行
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true

-- 搜索大小写不敏感,除非包含大写
vim.o.ignorecase = true
vim.o.smartcase = true

-- 搜索不要高亮
vim.o.hlsearch = true

-- 边输入边搜索
vim.o.incsearch = true

-- 命令行高为1,提供足够的显示控件
vim.o.cmdheight = 1

-- 当文件被外部文件修改时,自动加载
vim.o.autoread = true
vim.bo.autoread = true

-- 允许换行
vim.wo.wrap = true

-- 设置右侧底部显示输入命令
vim.o.ruler = true

-- 设置语法高亮
vim.o.syntax = 'enable'

-- 光标在行尾时<left><right>可以跳到下一行
vim.o.whichwrap = '<,>,[,]'

-- 允许隐藏被修改过的buffer
vim.o.hidden = true

-- 鼠标支持
vim.o.mouse = 'a'

-- 禁止创建备份文件
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- 设置缓冲区更新时间
vim.o.updatetime = 300

-- 设置timeoutlen 为等待键盘快捷键连击时间500毫秒,当你组合按键的时候生效
-- 遇到问题详见：https://github.com/nshen/learn-neovim-lua/issues/1
vim.o.timeoutlen = 1000

-- split window 从下边和右边出现
vim.o.splitbelow = true
vim.o.splitright = true

-- 自动补全不自动选中
vim.g.completeopt = "menu,menuone,noselect,noinsert"

-- 样式
vim.o.termguicolors = true
vim.opt.termguicolors = true

-- 是否显示不可见字符
vim.o.list = false

-- 不可见字符的显示,这里只把空格显示为一个点
vim.o.listchars = "space:·,tab:··"

-- 补全增强
vim.o.wildmenu = true

-- Dont' pass messages to |ins-completin menu|
vim.o.shortmess = vim.o.shortmess .. "c"

-- 补全最多显示10行
vim.o.pumheight = 10

-- 永远显示 tabline
vim.o.showtabline = 2

-- 使用增强状态栏插件后不再需要 vim 的模式提示
vim.o.showmode = false

local opt = vim.opt

-- 配置剪切板
opt.clipboard = "unnamed,unnamedplus"
-- set termguicolors to enable highlight groups
opt.termguicolors = true

opt.autowrite = true -- Enable auto write
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = {"buffers", "curdir", "tabpages", "winsize"}
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({W = true, I = true, c = true})
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = {"en"}
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.9.0") == 1 then
    opt.splitkeep = "screen"
    opt.shortmess:append({C = true})
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
-- Codeium's default keybindings can be disabled by setting 
-- @see https://github.com/Exafunction/codeium.vim
vim.g.codeium_disable_bindings = 1

-- nvim_treesitter options
-- 开启 Folding 模块, 使用zc折叠代码，zo打开折叠代码
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- 默认不要折叠
-- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
vim.opt.foldlevel = 99

-- Set other options
local colorscheme = require("helpers.colorscheme")
vim.cmd.colorscheme(colorscheme)
