
<h1 align='center'> hammerspoon config</h1>
<div align='center'>
  <img src='https://img.shields.io/badge/Hammerspoon-0.9.93-FFB100' alt='icon'/>
  <img src='https://img.shields.io/badge/Lua-5.4-00007C' alt='icon'/>
  <img src='https://img.shields.io/badge/Shell-417DDE' alt='icon'/>
</div>

## 参考
  - https://github.com/sugood/hammerspoon
  - https://github.com/KURANADO2/hammerspoon-kuranado

## TODO
 - [x] weather
 - [x] translate
 - [x] headphone
 - [ ] HSearch.spoon  阅读改进现有的检索
 - [ ] HeadphoneAutoPause.lua 连接/断开耳机时播放/暂停音乐播放器 
 - [ ] keymap fn+h/j/k/l ,映射为方向键，和karabiner功能相同，可以对比留一个使用
 - [ ] MouseCircle 鼠标点击显示圆圈,可以在演示时使用


## 本工程提供功能
### 功能菜单

鼠标单击功能项，即可启用/禁用功能项

---

### 窗口移动

替代 [Magnet](https://apps.apple.com/us/app/magnet/id441258766?mt=12) 进行窗口移动

---

### 应用切换

为应用配置快捷键，比 `⌘` `⇥` 和 Alfred 切换程序更高效（建议只为高频使用的一些软件分配快捷键）

---


### 实时网速显示

替代 [NetWorker Pro](https://apps.apple.com/us/app/networker-pro/id1163602886?mt=12) 实时显示网速（每两秒刷新一次）

---


### 按键回显

替代 [KeyCastr](https://github.com/keycastr/keycastr)



注：目前暂且实现了简单的按键回显，和 KeyCastr 相比在功能上仍相差甚远，如：
- 不支持多画布
- 画布不支持拖拽
- 缺少动画效果
- ...
感兴趣的同学欢迎提出实现思路，或直接贡献代码（不太懂 Objective-C，KeyCastr 的实现源码个人看不太懂）

---

### 快捷键列表查看

任意界面下按 `⌥` `/` 显示/隐藏快捷键列表

---


快捷键|功能
-|-
`⌃` `⌥` `←`|左半屏
`⌃` `⌥` `→`|右半屏
`⌃` `⌥` `↑`|上半屏
`⌃` `⌥` `↓`|下半屏
`⌃` `⌥` `=`|等比例放大窗口
`⌃` `⌥` `-`|等比例缩小窗口
`⌃` `⌥` `↩︎`|最大化
`⌃` `⌥` `⌘` `↑`|将窗口移动到上方屏幕
`⌃` `⌥` `⌘` `↓`|将窗口移动到下方屏幕
`⌃` `⌥` `⌘` `←`|将窗口移动到左侧屏幕
`⌃` `⌥` `⌘` `→`|将窗口移动到右侧屏幕
`⌥` `Q` |打开 QQ
`⌥` `W` |打开 WeChat
`⌥` `V` |打开 Visual Studio Code
`⌥` `F` |打开 Finder
`⌥` `C` |打开 Chrome
`⌥` `J` |打开 Intellij IDEA
`⌥` `N` |打开 WizNote
`⌥` `D` |打开 DataGrip
`⌥` `T` |打开 iTerm2
`⌥` `M` |打开 MailMaster
`⌥` `P` |打开 Postman
`⌥` `O` |打开 Word
`⌥` `E` |打开 Excel
`⌥` `Y` |打开 PyCharm
`⌥` `R` |打开 Another Redis Desktop Manager
`⌥` `/` |显示/隐藏快捷键列表

---

## 关于
### 关于应用 bundle id

上面配置中使用快捷键切换应用，需要拿到应用的 bundle id（请注意 bundle id 配置到 hammerspoon 中需要区分大小写，否则 console 会报错），可通过如下方式拿到：
```shell
osascript -e 'id of app "Name of App"'
```

另外，如果你使用的是比较新的 Mac 系统，终端下输入 `ls /Applications` 可能是看不到系统自带应用的，如下图，`ll` 查看不到 Mac 自带的邮件应用，但 Finder 打开 /Applications 目录则可以看到邮件应用

此时我们可以在 Finder 中选中邮件应用，右键：显示包内容 -> Contents -> 打开 info.plist 文件，找到 CFBundleIdentifier 配置项，该配置项的值即为 bundle id，当然此方法也适应于自己安装的应用

---

### 关于工程目录结构

```shell
.hammerspoon
├── .config 用户本地配置文件，保存了用户每个功能模块的启用/禁用状态
├── README.md
├── images 功能模块及 README 需要用到的图片
├── init.lua 脚本入口
└── modules 各个功能模块
    ├── application.lua 应用切换模块
    ├── base.lua 封装了 Lua 基本工具
    ├── config.lua 菜单默认配置，记录了每一项功能的默认启用/禁用状态
    ├── hotkey.lua 快捷键列表查看模块
    ├── keystroke-visualizer.lua 按键回显模块
    ├── menu.lua 菜单模块
    ├── system.lua 系统信息模块
    └── window.lua 窗口管理模块
```

