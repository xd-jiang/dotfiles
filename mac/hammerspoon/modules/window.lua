-- 窗口管理
require 'modules.shortcut'
local hotkey = require "hs.hotkey"
local window = require "hs.window"
local screen = require "hs.screen"
local layout = require "hs.layout"
local alert = require "hs.alert"
-- 关闭动画持续时间
window.animationDuration = 0

-- 窗口移动
-- 左半屏
hotkey.bind(windows.left.prefix, windows.left.key, nil, function()
    local win = window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- 右半屏
hotkey.bind(windows.right.prefix, windows.right.key, nil, function()
    local win = window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 2)
    f.y = max.y
    f.w = max.w / 2
    f.h = max.h
    win:setFrame(f)
end)

-- 上半屏
hotkey.bind(windows.up.prefix, windows.up.key, nil, function()
    local win = window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end)

-- 下半屏
hotkey.bind(windows.down.prefix, windows.down.key, nil, function()
    local win = window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y + (max.h / 2)
    f.w = max.w
    f.h = max.h / 2
    win:setFrame(f)
end)

-- 判断指定屏幕是否为竖屏
function isVerticalScreen(screen)
    if (screen:rotate() == 90 or screen:rotate() == 270) then
        return true
    else
        return false
    end
end

-- 居中
hotkey.bind(windows.center.prefix, windows.center.key, nil, function()
    local win = window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + (max.w / 4)
    f.y = max.y + (max.h / 4)
    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

-- 等比例放大窗口
hotkey.bind(windows.zoom.prefix, windows.zoom.key, nil, function()
    local win = window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = f.w + 40
    f.h = f.h + 40
    f.x = f.x - 20
    f.y = f.y - 20
    if (f.x < max.x) then
        f.x = max.x
    end
    if (f.y < max.y) then
        f.y = max.y
    end
    if (f.w > max.w) then
        f.w = max.w
    end
    if (f.h > max.h) then
        f.h = max.h
    end
    win:setFrame(f)
end)

-- 等比例缩小窗口
hotkey.bind(windows.narrow.prefix, windows.narrow.key, nil, function()
    local win = window.focusedWindow()
    local f = win:frame()
    f.w = f.w - 40
    f.h = f.h - 40
    f.x = f.x + 20
    f.y = f.y + 20
    win:setFrame(f)
end)

-- 最大化
hotkey.bind(windows.max.prefix, windows.max.key, nil, function()
    local win = window.focusedWindow()
    win:maximize()
end)

-- 将窗口移动到上方屏幕
hotkey.bind(windows.to_up.prefix, windows.to_up.key, nil, function()
    local win = window.focusedWindow()
    if (win) then
        win:moveOneScreenNorth()
    end
end)

-- 将窗口移动到下方屏幕
hotkey.bind(windows.to_down.prefix, windows.to_down.key, nil, function()
    local win = window.focusedWindow()
    if (win) then
        win:moveOneScreenSouth()
    end
end)

-- 将窗口移动到左侧屏幕
hotkey.bind(windows.to_left.prefix, windows.to_left.key, nil, function()
    local win = window.focusedWindow()
    if (win) then
        win:moveOneScreenWest()
    end
end)

-- 将窗口移动到右侧屏幕
hotkey.bind(windows.to_right.prefix, windows.to_right.key, nil, function()
    local win = window.focusedWindow()
    if (win) then
        win:moveOneScreenEast()
    end
end)

-- move a window to next monitor

function moveWindowMonitor(direction)
    local win = hs.window.frontmostWindow()
    if direction == "west" then
        win = win:moveOneScreenWest()
    else -- direciton == "east"
        win = win:moveOneScreenEast()
    end
end

hs.hotkey.bind(hyperOptCmd, "n", "Move window to the right monitor", function()
    moveWindowMonitor("west")
end)

hs.hotkey.bind(hyperOptCmd, "m", "Move window to the left monitor", function()
    moveWindowMonitor("east")
end)

-- maximized active window and move to selected monitor
local moveto = function(win, n)
    local screens = screen.allScreens()
    if n > #screens then
        alert.show("Only " .. #screens .. " monitors ")
    else
        local toWin = screen.allScreens()[n]:name()
        alert.show("Move " .. win:application():name() .. " to " .. toWin)

        layout.apply({{nil, win:title(), toWin, layout.maximized, nil, nil}})

    end
end

-- move cursor to monitor 1 and maximize the window
hotkey.bind(hyperOpt, "1", function()
    local win = window.focusedWindow()
    moveto(win, 1)
end)

hotkey.bind(hyperOpt, "2", function()
    local win = window.focusedWindow()
    moveto(win, 2)
end)

hotkey.bind(hyperOpt, "3", function()
    local win = window.focusedWindow()
    moveto(win, 3)
end)
