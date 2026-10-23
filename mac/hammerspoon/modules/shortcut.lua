--  功能键(窗口管理,弹出层)使用 hyperOpt
-- 窗口跨屏幕管理使用 hyperOptCmd
OptionKey = {"Option"}
hyperOpt = {"Option", "shift"}
hyperOptCmd = {"shift", "Option", "Command"}

-- prefix：表示快捷键前缀，可选值：Ctrl、Option、Command
-- key：可选值 [A-Z]、[1-9]、Left、Right、Up、Down、-、=、/
-- message 表示提示信息

-- 窗口管理快捷键配置
windows = {
    -- 左半屏
    left = {
        prefix = hyperOpt,
        key = "H",
        message = "Left Half"
    },
    -- 右半屏
    right = {
        prefix = hyperOpt,
        key = "L",
        message = "Right Half"
    },
    -- 上半屏
    up = {
        prefix = hyperOpt,
        key = "K",
        message = "Up Half"
    },
    -- 下半屏
    down = {
        prefix = hyperOpt,
        key = "J",
        message = "Down Half"
    },
    -- 居中
    center = {
        prefix = hyperOpt,
        key = "C",
        message = "Center"
    },
    -- 等比例放大窗口
    zoom = {
        prefix = hyperOpt,
        key = "=",
        message = "Zoom Window"
    },
    -- 等比例缩小窗口
    narrow = {
        prefix = hyperOpt,
        key = "-",
        message = "Narrow Window"
    },
    -- 最大化
    max = {
        prefix = hyperOpt,
        key = "Return",
        message = "Max Window"
    },
    -- 将窗口移动到上方屏幕
    to_up = {
        prefix = hyperOptCmd,
        key = "k",
        message = "Move To Up Screen"
    },
    -- 将窗口移动到下方屏幕
    to_down = {
        prefix = hyperOptCmd,
        key = "J",
        message = "Move To Down Screen"
    },
    -- 将窗口移动到左侧屏幕
    to_left = {
        prefix = hyperOptCmd,
        key = "H",
        message = "Move To Left Screen"
    },
    -- 将窗口移动到右侧屏幕
    to_right = {
        prefix = hyperOptCmd,
        key = "L",
        message = "Move To Right Screen"
    }
}

-- 应用切换快捷键配置
applications = {{
    prefix = {"Option"},
    key = "V",
    message = "VSCode",
    bundleId = "com.microsoft.VSCode"
}, {
    prefix = {"Option"},
    key = "C",
    message = "Chrome",
    bundleId = "com.google.Chrome"
}, {
    prefix = {"Option"},
    key = "T",
    message = "Terminal",
    bundleId = "com.googlecode.iterm2"
}, {
    prefix = {"Option"},
    key = "M",
    message = "QQMusic",
    bundleId = "com.tencent.QQMusicMac"
}, {
    prefix = {"Option"},
    key = "w",
    message = "WebStorm",
    bundleId = "com.jetbrains.WebStorm"
}, {
    prefix = {"Option"},
    key = "d",
    message = "Typora",
    bundleId = "abnerworks.Typora"
}, {
    prefix = {"Option"},
    key = "i",
    message = "IDEA",
    bundleId = "com.jetbrains.intellij"
}, {
    prefix = {"Option"},
    key = "a",
    message = "apipost",
    bundleId = "com.apipost.apipost.fe.desctop.cn.7.x"
}}

-- 搜索快捷键配置
search = {
    prefix = hyperOpt,
    key = "S"
}
git = {
    prefix = hyperOpt,
    key = "G"
}
translate = {
    prefix = hyperOpt,
    key = "T"
}
rephrase = {
    prefix = hyperOpt,
    key = "R"
}
bookmarkKey = {
    prefix = hyperOpt,
    key = "M"
}
colorkKey = {
    prefix = hyperOpt,
    key = "p"
}
Lock = {
    prefix = {"Option"},
    key = "L"
}

