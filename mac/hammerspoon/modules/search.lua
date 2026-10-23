require 'modules.base'
require 'modules.shortcut'

local choices = {}

local SeachUrl = {
    {key = "g", text = "Goolge", url = "https://www.google.com/search?q="},
    {key = "b", text = "Baidu", url = "https://www.baidu.com/s?wd="},
    {key = "h", text = "Github", url = "https://github.com/search?q="},
    {key = "n", text = "npm", url = "https://www.npmjs.com/search?q="},
    {key = "f", text = "百度翻译", url = "https://fanyi.baidu.com/"}
}

local searchChooser = hs.chooser.new(function(choice)
    if not choice then return end
    choice.text = trim(choice.text)
    choice.query = trim(choice.query)
    local url = ""
    if choice.key == "f" then
        if CheckChinese(choice.query) then
            url = choice.url .. '#zh/en/' .. encodeURI(choice.query)
        else
            url = choice.url .. '#en/zh/' .. encodeURI(choice.query)
        end
    else
        url = choice.url .. encodeURI(choice.query)
    end
    local default_browser = hs.urlevent.getDefaultHandler('http')
    hs.urlevent.openURLWithBundle(url, default_browser)
end)

searchChooser:width(30)
searchChooser:rows(10)
searchChooser:fgColor({hex = '#51c4d3'})
searchChooser:placeholderText('请输入')

local function request(query)
    choices = {}
    query = trim(query)

    -- 如果查询字符串中包含冒号，则解析快捷方式
    if string.find(query, ":") then
        local shortcut = string.sub(query, 1, string.find(query, ":") - 1)
        local searchStr = string.sub(query, string.find(query, ":") + 1)
        for _, w in ipairs(SeachUrl) do
            if w.key == shortcut then

                table.insert(choices, {
                    text = w.text,
                    key = w.key,
                    subText = w.url,
                    query = searchStr,
                    url = w.url
                })
            end
        end
        searchChooser:choices(choices)
        return
    end

    if query == '' then return end

    for _, w in ipairs(SeachUrl) do
        table.insert(choices, {
            text = w.text,
            key = w.key,
            subText = w.url,
            query = query,
            url = w.url
        })
        searchChooser:choices(choices)
    end
end
-- 上下键选择
local select_key = hs.eventtap.new({hs.eventtap.event.types.keyDown},
                                   function(event)
    -- 只在 searchChooser 显示时，才监听键盘按下
    if not searchChooser:isVisible() then return end
    local len = 0;
    local keycode = event:getKeyCode()
    local key = hs.keycodes.map[keycode]

    number = searchChooser:selectedRow();
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
    row_contents = searchChooser:selectedRowContents(number)
end):start()

hs.hotkey.bind(search.prefix, search.key, function()
    allWindows = hs.window.allWindows();
    searchChooser:query('')
    searchChooser:show()
end)

local changed_chooser = searchChooser:queryChangedCallback(function()
    hs.timer.doAfter(0.1, function()
        local query = searchChooser:query();
        request(query)
    end)
end)
