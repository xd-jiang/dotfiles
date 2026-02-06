local map = require("helpers.keys").map
local maps = require("helpers.keys").maps

return {
    "honza/vim-snippets", "github/copilot.vim", {
        "neoclide/coc.nvim",
        branch = 'release',
        run = 'pnpm install --frozen-lockfile',
        init = function()
            vim.g.coc_global_extensions = {
                "coc-yaml", "coc-toml", "@yaegassy/coc-tailwindcss3", "coc-css",
                'coc-eslint', 'coc-sql', "coc-emmet", "coc-tabnine",
                '@yaegassy/coc-volar', '@yaegassy/coc-volar-tools',
                "coc-highlight", "coc-html", 'coc-go', "coc-rust-analyzer",
                "coc-htmldjango", "coc-json", "coc-pyright",
                "coc-rust-analyzer", "coc-tsserver", "coc-tag", "coc-clangd",
                "coc-snippets", "coc-spell-checker", "coc-sumneko-lua"
            }
        end,
        config = function()
            vim.o.tagfunc = "CocTagFunc"
            vim.cmd([[
        augroup CocAutocomands
          autocmd!
          " Show function signature while completing args
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
          autocmd FileType
                \ json,js,html,c,cpp,h,hh
                \ setlocal formatexpr=CocAction('formatSelected')
        augroup END
      ]])

            maps({
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
                {'o', 'af', '<Plug>(coc-funcobj-a)', {silent = true}},
                -- 选定整个class
                {'x', 'ic', '<Plug>(coc-classobj-i)', {silent = true}},
                {'o', 'ic', '<Plug>(coc-classobj-i)', {silent = true}},
                {'x', 'ac', '<Plug>(coc-classobj-a)', {silent = true}},
                {'o', 'ac', '<Plug>(coc-classobj-a)', {silent = true}},
                {
                    'n', '<leader>lj', '<CMD>lua _G.show_docs()<CR>',
                    {silent = true}
                }, {'n', 'gp', '<Plug>(coc-diagnostic-prev)', {silent = true}},
                {'n', 'gn', '<Plug>(coc-diagnostic-next)', {silent = true}},
                -- 格式化代码
                -- { 'n', '<leader>fm', '<Plug>(coc-format-selected)<CR>',      {silent = true } },
                {
                    'n', '<leader>fm', ":call CocAction('format')<CR>",
                    {silent = true}
                },
                {
                    'x', '<leader>fm', '<Plug>(coc-format-selected)<CR>',
                    {silent = true}
                }, -- 触发snippets
                {'i', '<C-j>', '<Plug>(coc-snippets-expand-jump)', {}},
                -- Apply codeAction to the selected region
                {
                    'n', '<leader>la', '<Plug>{coc-codeaction-selected}',
                    {silent = true}
                },
                {
                    'x', '<leader>la', '<Plug>{coc-codeaction-selected}',
                    {silent = true}
                }, -- Remap keys for applying codeActions to the current buffer
                {"n", "<leader>ac", "<Plug>{coc-codeaction}", opts},
                -- Apply the most preferred quickfix action on the current line.
                {"n", "<leader>li", "<Plug>(coc-fix-current)", opts},
                -- 启动复制框
                {
                    "n", "<space>ly", ":<C-u>CocList -A --normal yank<cr>",
                    {silent = true}
                }, -- 刷新提示框
                {
                    'i', '<C-space>', "coc#refresh()",
                    {silent = true, noremap = true, expr = true}
                }, -- tab为选中第一条
                {
                    'i', '<TAB>',
                    "coc#pum#visible() ? coc#pum#confirm() :  \"\\<TAB>\"",
                    {silent = true, noremap = true, expr = true}
                }, {
                    'i', '<C-n>',
                    "coc#pum#visible() ? coc#pum#next(1) : \"\\<C-n>\" ",
                    {silent = true, noremap = true, expr = true}
                }, {
                    'i', '<C-p>',
                    "coc#pum#visible() ? coc#pum#prev(1) : \"\\<C-p>\"",
                    {silent = true, noremap = true, expr = true}
                }, {
                    'i', '<cr>',
                    "coc#pum#visible() ? coc#pum#confirm() : \"\\<c-g>u\\<cr>\\<c-r>=coc#on_enter()\\<cr>\"",
                    {silent = true, noremap = true, expr = true}
                },
                {
                    'n', '<F3>', ":silent CocRestart<cr>",
                    {silent = true, noremap = true}
                }, {
                    'n', '<F4>',
                    "get(g:, 'coc_enabled', 0) == 1 ? ':CocDisable<cr>' : ':CocEnable<cr>'",
                    {silent = true, noremap = true, expr = true}
                }, {
                    'n', '<F9>', ":CocCommand snippets.editSnippets<cr>",
                    {silent = true, noremap = true}
                }, -- 列出所有的错误
                {
                    'n', '<leader>le',
                    ":CocList --auto-preview diagnostics<cr>", {silent = true}
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
            })
        end
    }
}
