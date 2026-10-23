require 'modules.base'
require 'modules.shortcut'
require 'modules.cache'

local choices = {}

setBMInCache()

local bookmarks = readBMInCache()

local function request(query)
    choices = {}
    query = trim(query)
    if query == '' then
        return
    end
    for _, w in ipairs(bookmarks) do
        if (string.find(w.name, query) == nil and string.find(w.url, query) == nil) then
        else
            table.insert(choices, {
                text = w.name,
                subText = w.url,
                url = w.url
            })
            bookmarksChooser:choices(choices)
        end
    end
end
-- 上下键选择
local select_key = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
    -- 只在 bookmarksChooser 显示时，才监听键盘按下
    if not bookmarksChooser:isVisible() then
        return
    end
    local len = 0;
    local keycode = event:getKeyCode()
    local key = hs.keycodes.map[keycode]

    number = bookmarksChooser:selectedRow();
    if 'down' == key then
        if number < len then
            number = number + 1
        else
            number = 1
        end
    end
    if 'up' == key then
        if number > 1 then
            number = number - 1
        else
            number = len
        end
    end
    row_contents = bookmarksChooser:selectedRowContents(number)
end):start()

bookmarksChooser = hs.chooser.new(function(choice)
    if not choice then
        return
    end
    choice.text = trim(choice.text)
    local default_browser = hs.urlevent.getDefaultHandler('http')
    hs.urlevent.openURLWithBundle(choice.url, default_browser)
end)
bookmarksChooser:width(30)
bookmarksChooser:rows(10)
bookmarksChooser:fgColor({
    hex = '#51c4d3'
})
bookmarksChooser:placeholderText('请输入')

hs.hotkey.bind(bookmarkKey.prefix, bookmarkKey.key, function()
    allWindows = hs.window.allWindows();
    bookmarksChooser:query('')
    bookmarksChooser:show()
end)

local changed_chooser = bookmarksChooser:queryChangedCallback(function()
    hs.timer.doAfter(0.1, function()
        local query = bookmarksChooser:query();
        request(query)
    end)
end)
