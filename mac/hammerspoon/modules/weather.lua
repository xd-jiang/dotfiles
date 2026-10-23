local urlApi =
    'https://v1.yiketianqi.com/api?unescape=1&version=v91&appid=41178329&appsecret=VMjzuYu1&ext=&cityid=101191101'
local menubar = hs.menubar.new()
local menuData = {}
local user_agent_str =
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36"

local requsetHeader = {
    ["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    ["Accept-Encoding"] = "gzip, deflate",
    ["Accept-Language"] = "zh-CN,zh;q=0.9",
    ["Cache-Control"] = "no-cache",
    ["Connection"] = "keep-alive",
    ["Host"] = "v1.yiketianqi.com",
    ["Pragma"] = "no-cache",
    ["Upgrade-Insecure-Requests"] = "1",
    ["User-Agent"] = user_agent_str
}

local weaEmoji = {
    lei = '⛈',
    qing = '☀️',
    shachen = '😷',
    wu = '🌫',
    xue = '❄️',
    yu = '🌧',
    yujiaxue = '🌨',
    yun = '☁️',
    zhenyu = '🌧',
    yin = '⛅️',
    default = ''
}

function updateMenubar()
    menubar:setTooltip("Weather Info")
    menubar:setMenu(menuData)
end

function getWeather()
    print("getWeather")
    hs.http.asyncGet(urlApi, requsetHeader, function(code, body, htable)
        if code ~= 200 then
            print('get weather error:' .. code)
            return
        end
        rawjson = hs.json.decode(body)
        city = rawjson.city
        menuData = {}
        for k, v in pairs(rawjson.data) do
            if k == 1 then
                menubar:setTitle(weaEmoji[v.wea_img])
                titlestr = string.format("%s %s %s 🌡️%s 💧%s 💨%s 🌬 %s %s", city, weaEmoji[v.wea_img],
                    v.day, v.tem, v.humidity, v.air, v.win_speed, v.wea)
                item = {
                    title = titlestr
                }
                table.insert(menuData, item)
                table.insert(menuData, {
                    title = '-'
                })
            else
                -- titlestr = string.format("%s %s %s %s", v.day, v.wea, v.tem, v.win_speed)
                titlestr = string.format("%s %s %s 🌡️%s 🌬%s %s", city, weaEmoji[v.wea_img], v.day, v.tem,
                    v.win_speed, v.wea)
                item = {
                    title = titlestr
                }
                table.insert(menuData, item)
            end
        end
        updateMenubar()
    end)
end

menubar:setTitle('⌛')
getWeather()
updateMenubar()
hs.timer.doEvery(3600, getWeather)
