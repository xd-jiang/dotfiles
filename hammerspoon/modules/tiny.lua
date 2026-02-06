hs.hotkey.bind(Lock.prefix, Lock.key, function()
    hs.caffeinate.lockScreen()
end)
colorDialog = hs.dialog.color

function openColorDialog()
    hs.openConsole(true)
    colorDialog.show()
    colorDialog.mode("RGB")
    colorDialog.callback(function(a, b)
        if b then
            hs.closeConsole()
        end
    end)
    hs.closeConsole()
end

-- 设置颜色拾取快键键
hs.hotkey.bind(colorkKey.prefix, colorkKey.key, function()
    openColorDialog()
end)
