local map = require("helpers.keys").map
local maps = require("helpers.keys").maps

-- Blazingly fast way out of insert mode
map("i", "jk", "<ess>")

local system = vim.loop.os_uname().sysname

if system == 'Darwin' then
    -- strl + / 替换原来的gss
    maps({
        {"n", "<C-/>", "gss", {noremap = false}},
        {"v", "<C-/>", "gss", {noremap = false}}
    })
elseif system == 'window' then
    -- strl + / 替换原来的gss
    maps({
        {"n", "<C-_>", "gss", {noremap = false}},
        {"v", "<C-_>", "gss", {noremap = false}}
    })
end

-- 设置leader key为空字符串
mapssleader = ' '
mapsslocalleader = ' '

-- 设置option常量
local opt = {noremap = true, silent = true}

-- $跳到行尾不带空格(交换$和g_)
maps({
    {'v', '$', 'g_', opt}, {'v', 'g_', '$', opt}, {'n', '$', 'g_', opt},
    {'n', 'g_', '$', opt}
})

-- 命令行下 Ctrl + j/k 上一个下一个
maps({
    {'c', '<C-j>', '<C-n>', {noremap = false}},
    {'c', '<C-k>', '<C-p>', {noremap = false}}
})

-- 保存文件
maps({{'n', '<leader>w', ':w<CR>', opt}, {'n', '<leader>wq', ':wqa!<CR>', opt}})

-- 退出
-- map("n", "qq", ":q!<CR>", opt)
maps({{"n", "<leader>q", ":qa!<CR>", opt}})

-- 当一行过长的时候jk移动可以被gj和gk代替
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'",
               {expr = true, silent = true})
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'",
               {expr = true, silent = true})

-- 上下滚动浏览
maps({
    {'n', '<C-j>', '5j', opt}, {'n', '<C-k>', '5k', opt},
    {'v', '<C-j>', '5j', opt}, {'v', '<C-k>', '5k', opt}
})

-- ctrl u/d 上下移动9行，默认ctrl u/d是移动半屏
maps({{'n', '<C-u>', '10k', opt}, {'n', '<C-d>', '10j', opt}})

-- 开启魔术搜索,即可以通过正则来搜索
maps({
    {"n", "/", "/\\v", {noremap = true, silent = false}},
    {"v", "/", "/\\v", {noremap = true, silent = false}}
})

-- visual模式下缩进代码, 缩进后仍然可以继续选中区域
maps({{'v', '<', '<gv', opt}, {'v', '>', '>gv', opt}})

-- 上下移动选中文本
maps({
    {"v", "J", ":move '>+1<CR>gv-gv", opt},
    {"v", "K", ":move '<-2<CR>gv-gv", opt}
})

-- 在visual mode 里粘贴不要复制
maps({{"v", "p", '"_dP', opt}})

-----------------------------------------------------------------------------------------
-- 分屏快捷键
-----------------------------------------------------------------------------------------
maps({
    -- 取消 s 默认功能
    {'n', 's', '', opt}, {'n', 'sv', ':vsp<CR>', opt},
    {'n', 'sh', ':sp<CR>', opt}, -- 关闭当前
    {'n', 'sc', '<C-w>c', opt}, -- 关闭其他
    {'n', 'so', '<C-w>o', opt}, -- alt + hjkl  窗口之间跳转, win中生效
    {"n", "<A-h>", "<C-w>h", opt}, {"n", "<A-j>", "<C-w>j", opt},
    {"n", "<A-k>", "<C-w>k", opt}, {"n", "<A-l>", "<C-w>l", opt},
    -- <leader> +jhjkl 窗口之间跳转
    -- 左右比例控制
    {"n", "<C-Left>", ":vertical resize -2<CR>", opt},
    {"n", "<C-Right>", ":vertical resize +2<CR>", opt},
    {"n", "s,", ":vertical resize -10<CR>", opt},
    {"n", "s.", ":vertical resize +10<CR>", opt}, -- 上下比例
    {"n", "sj", ":resize +10<CR>", opt}, {"n", "sk", ":resize -10<CR>", opt},
    {"n", "<C-Down>", ":resize +2<CR>", opt},
    {"n", "<C-Up>", ":resize -2<CR>", opt}, -- 相等比例
    {"n", "s=", "<C-w>=", opt}
})

-- <leader>t 开启终端
map('n', '<leader>t', ':sp | terminal<CR>', opt)
map('n', '<leader>vt', ':vsp | terminal<CR>', opt)
-- <Esc> 退出终端
map('t', '<Esc>', '<C-\\><C-N>', opt)
-- 终端窗口中进行窗口切换
map('t', '<A-h>', [[ <C-\><C-N><C-w>h ]], opt)
map('t', '<A-j>', [[ <C-\><C-N><C-w>j ]], opt)
map('t', '<A-k>', [[ <C-\><C-N><C-w>k ]], opt)
map('t', '<A-l>', [[ <C-\><C-N><C-w>l ]], opt)

-- 文件浏览树相关配置
maps({
    {"n", "<leader>e", ":NeoTreeShow<CR>", opt},
    {"n", "<leader>te", ":NeoTreeFocus<CR>", opt},
    {"n", "<leader>tc", ":NeoTreeClose<CR>", opt},
    -- 在文件树中打开文件
    {"n", "<leader>to", ":NeoTreeFindFile<CR>", opt}
})

-------------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------------
local pluginKeys = {}

-- bufferline, Tabs标签页相关配置
if system == 'Darwin' then
    maps({
        -- 左右Tab切换
        {"n", "<S-tab>", ":BufferLineCyclePrev<CR>", opt},
        {"n", "<tab>", ":BufferLineCycleNext<CR>", opt}
    })
elseif system == 'window' then
    maps({
        -- 左右Tab切换
        {"n", "<C-H>", ":BufferLineCyclePrev<CR>", opt},
        {"n", "<C-L>", ":BufferLineCycleNext<CR>", opt}
    })
end

pluginKeys.nvimTreeList = { -- 打开文件或文件夹
    {key = {"o", "<2-LeftMouse>"}, action = "edit"},
    {key = "<CR>", action = "system_open"}, -- v分屏打开文件
    {key = "v", action = "vsplit"}, -- h分屏打开文件
    {key = "h", action = "split"}, -- Ignore (node_modules)
    {key = "i", action = "toggle_ignored"}, -- Hide (dotfiles)
    {key = ".", action = "toggle_dotfiles"}, {key = "R", action = "refresh"},
    -- 文件操作
    {key = "a", action = "create"}, {key = "d", action = "remove"},
    {key = "r", action = "rename"}, {key = "x", action = "cut"},
    {key = "c", action = "copy"}, {key = "p", action = "paste"},
    {key = "y", action = "copy_name"}, {key = "Y", action = "copy_path"},
    {key = "gy", action = "copy_absolute_path"},
    {key = "I", action = "toggle_file_info"}, {key = "n", action = "tabnew"},
    -- 进入下一级
    {key = {"]"}, action = "cd"}, -- 进入上一级
    {key = {"["}, action = "dir_up"}
}

-- Telescope 列表中 插入模式快捷键
pluginKeys.telescopeList = {
    i = {
        -- find
        ["<leader>ff"] = {"<cmd> Telescope find_files <CR>", "Find files"},
        ["<leader>fa"] = {
            "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
            "Find all"
        },
        ["<leader>fw"] = {"<cmd> Telescope live_grep <CR>", "Live grep"},
        ["<leader>fb"] = {"<cmd> Telescope buffers <CR>", "Find buffers"},
        ["<leader>fh"] = {"<cmd> Telescope help_tags <CR>", "Help page"},
        ["<leader>fo"] = {"<cmd> Telescope oldfiles <CR>", "Find oldfiles"},
        ["<leader>fz"] = {
            "<cmd> Telescope current_buffer_fuzzy_find <CR>",
            "Find in current buffer"
        },

        -- git
        ["<leader>cm"] = {"<cmd> Telescope git_commits <CR>", "Git commits"},
        ["<leader>gt"] = {"<cmd> Telescope git_status <CR>", "Git status"},

        -- pick a hidden term
        ["<leader>pt"] = {"<cmd> Telescope terms <CR>", "Pick hidden term"},

        -- theme switcher
        ["<leader>th"] = {"<cmd> Telescope themes <CR>", "Nvchad themes"},

        ["<leader>ma"] = {"<cmd> Telescope marks <CR>", "telescope bookmarks"}
    }
}
-- 代码注释插件
-- see ./lua/plugin-config/comment.lua
-- 禁用item2的find cursor
-- defaults write com.googlecode.iterm2 NSUserKeyEquivalents -dict-add "Find Cursor" nil
pluginKeys.comment = {
    -- Normal 模式快捷键
    toggler = {
        line = "gcc", -- 行注释
        block = "gbc" -- 块注释
    },
    -- Visual 模式
    opleader = {line = "gc", bock = "gb"}
}
-- 自定义 toggleterm 3个不同类型的命令行窗口
-- <leader>ta 浮动
-- <leader>tb 右侧
-- <leader>tc 下方
-- 特殊lazygit 窗口，需要安装lazygit
-- <leader>tg lazygit
pluginKeys.mapToggleTerm = function(toggleterm)
    vim.keymap.set({"n", "t"}, "<leader>tf", toggleterm.toggleFloat)
    vim.keymap.set({"n", "t"}, "<leader>tv", toggleterm.toggleVertical)
    vim.keymap.set({"n", "t"}, "<leader>th", toggleterm.toggleHorizontal)
    vim.keymap.set({"n", "t"}, "<leader>tg", toggleterm.toggleGit)
end

pluginKeys.coc = {
    -- 重命名
    {'n', '<leader>lr', '<Plug>{coc-rename}', {silent = true}},
    -- 查看函数定义
    {'n', 'gd', '<Plug>{coc-definition}', {silent = true}},
    {'n', 'gt', '<Plug>(coc-type-definition)', {silent = true}},
    {'n', 'gi', '<Plug>{coc-implementation}', {silent = true}},
    {'n', 'gr', '<Plug>(coc-references)', {silent = true}},
    -- 选定整个function
    {'x', 'if', '<Plug>(coc-funcobj-i)', {silent = true}},
    {'o', 'if', '<Plug>(coc-funcobj-i)', {silent = true}},
    {'x', 'af', '<Plug>(coc-funcobj-a)', {silent = true}},
    {'o', 'af', '<Plug>(coc-funcobj-a)', {silent = true}}, -- 选定整个class
    {'x', 'ic', '<Plug>(coc-classobj-i)', {silent = true}},
    {'o', 'ic', '<Plug>(coc-classobj-i)', {silent = true}},
    {'x', 'ac', '<Plug>(coc-classobj-a)', {silent = true}},
    {'o', 'ac', '<Plug>(coc-classobj-a)', {silent = true}},
    {'n', '<leader>lj', '<CMD>lua _G.show_docs()<CR>', {silent = true}},
    {'n', 'gp', '<Plug>(coc-diagnostic-prev)', {silent = true}},
    {'n', 'gn', '<Plug>(coc-diagnostic-next)', {silent = true}},
    -- 格式化代码
    -- { 'n', '<leader>fm', '<Plug>(coc-format-selected)<CR>',      {silent = true } },
    {'n', '<leader>fm', ":call CocAction('format')<CR>", {silent = true}},
    {'x', '<leader>fm', '<Plug>(coc-format-selected)<CR>', {silent = true}},
    -- 触发snippets
    {'i', '<C-j>', '<Plug>(coc-snippets-expand-jump)', {}},
    -- Apply codeAction to the selected region
    {'n', '<leader>la', '<Plug>{coc-codeaction-selected}', {silent = true}},
    {'x', '<leader>la', '<Plug>{coc-codeaction-selected}', {silent = true}},
    -- Remap keys for applying codeActions to the current buffer
    {"n", "<leader>ac", "<Plug>{coc-codeaction}", opts},
    -- Apply the most preferred quickfix action on the current line.
    {"n", "<leader>li", "<Plug>(coc-fix-current)", opts}, -- 启动复制框
    {"n", "<space>ly", ":<C-u>CocList -A --normal yank<cr>", {silent = true}},
    -- 刷新提示框
    {
        'i', '<C-space>', "coc#refresh()",
        {silent = true, noremap = true, expr = true}
    }, -- tab为选中第一条
    {
        'i', '<TAB>', "coc#pum#visible() ? coc#pum#confirm() :  \"\\<TAB>\"",
        {silent = true, noremap = true, expr = true}
    }, {
        'i', '<C-n>', "coc#pum#visible() ? coc#pum#next(1) : \"\\<C-n>\" ",
        {silent = true, noremap = true, expr = true}
    }, {
        'i', '<C-p>', "coc#pum#visible() ? coc#pum#prev(1) : \"\\<C-p>\"",
        {silent = true, noremap = true, expr = true}
    }, {
        'i', '<cr>',
        "coc#pum#visible() ? coc#pum#confirm() : \"\\<c-g>u\\<cr>\\<c-r>=coc#on_enter()\\<cr>\"",
        {silent = true, noremap = true, expr = true}
    }, {'n', '<F3>', ":silent CocRestart<cr>", {silent = true, noremap = true}},
    {
        'n', '<F4>',
        "get(g:, 'coc_enabled', 0) == 1 ? ':CocDisable<cr>' : ':CocEnable<cr>'",
        {silent = true, noremap = true, expr = true}
    }, {
        'n', '<F9>', ":CocCommand snippets.editSnippets<cr>",
        {silent = true, noremap = true}
    }, -- 列出所有的错误
    {
        'n', '<leader>le', ":CocList --auto-preview diagnostics<cr>",
        {silent = true}
    }, -- 翻译所在单词
    {'n', 'mm', "<Plug>(coc-translator-p)", {silent = true}},
    {'v', 'mm', "<Plug>(coc-translator-pv)", {silent = true}},
    -- 前往上一个git改动区域
    {'n', '(', "<Plug>(coc-git-prevchunk)", {silent = true}},
    -- 前往下一个git改动区域
    {'n', ')', "<Plug>(coc-git-nextchunk)", {silent = true}}, {
        'n', '<leader>lg',
        "get(b:, 'coc_git_blame', '') ==# 'Not committed yet' ? \"<Plug>(coc-git-chunkinfo)\" : \"<Plug>(coc-git-commit)\"",
        {silent = true, expr = true}
    }, -- 可以显示每一行上次是谁提交的
    {
        'n', '\\g',
        ":call coc#config('git.addGBlameToVirtualText',  !get(g:coc_user_config, 'git.addGBlameToVirtualText', 0)) | call nvim_buf_clear_namespace(bufnr(), -1, line('.') - 1, line('.'))<cr>",
        {silent = true}
    }

}

return pluginKeys
