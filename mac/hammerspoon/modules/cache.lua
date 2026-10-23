require 'modules.base'
-- 是否是git项目，判断目录里是否有 .git 文件夹
local function isGitSync(dir)
    local gitDir = dir .. "/.git"
    local attr = hs.fs.attributes(gitDir)
    if attr == nil then
        return false
    else
        return true
    end
end

function readFileInCache(fileDir)
    local filesList = {}
    for item in hs.fs.dir(fileDir) do
        if item ~= "." and item ~= ".." and item ~= "node_modules" then
            local fullPath = fileDir .. "/" .. item
            local attr = hs.fs.attributes(fullPath, "mode")
            if attr == "directory" then
                if isGitSync(fullPath) then
                    table.insert(filesList, {
                        name = item,
                        path = fullPath
                    })
                else
                    local subFilesList = readFileInCache(fullPath) -- 递归读取文件
                    for _, subItem in ipairs(subFilesList) do
                        table.insert(filesList, subItem)
                    end
                end
            end
        end
    end
    return filesList
end

function loadBookMarks()
    local bookMarKList = {}
    local file = io.open(BookmarksPath, "r")
    local bookmarks = file:read("*all")
    local bookmarksList = hs.json.decode(bookmarks);
    for _, item in pairs(bookmarksList) do
        if (type(item) == "table") then
            return readBookMarks(item.bookmark_bar.children[1].children)
        end
    end
end

function readBookMarks(bar)
    local bookMarKList = {}
    if type(bar) == "table" then
        for _, item in ipairs(bar) do
            if item.url then
                table.insert(bookMarKList, item)
            end
            if item.children then
                local subBookMarKList = readBookMarks(item.children)
                for _, subItem in ipairs(subBookMarKList) do
                    table.insert(bookMarKList, subItem)
                end
            end
        end
    elseif bar.children then
        for _, item in ipairs(bar.children) do
            if item.type == "url" then
                table.insert(bookMarKList, item)
            else
                local subBookMarKList = readBookMarks(item)
                for _, subItem in ipairs(subBookMarKList) do
                    table.insert(bookMarKList, subItem)
                end
            end
        end
    end
    return bookMarKList
end

function setFileInCache()
    local filesList = readFileInCache(GIT_FILES_DIR);
    local gitJson = hs.json.encode(filesList) -- 将表转换为JSON字符串
    local file = io.open(gitCacheFile, "w")
    file:write(gitJson)
    file:close()
end

function setBMInCache()
    local bookMarKList = loadBookMarks()
    local bmJson = hs.json.encode(bookMarKList) -- 将表转换为JSON字符串
    local file = io.open(bookmarksFile, "w")
    file:write(bmJson)
    file:close()
end

function readBMInCache()
    hs.fs.mkdir(bookmarksFile)
    local cacheFile = io.open(bookmarksFile, "r")
    if cacheFile then
        local content = cacheFile:read("*a")
        if content ~= "" then
            return hs.json.decode(content)
        end
    end
    return {}
end