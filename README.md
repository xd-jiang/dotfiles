# Dotfiles

个人开发环境配置文件，支持 macOS、Linux 和 Windows 三个平台。

## ✨ 特性

- 🚀 **一键安装** - 统一的跨平台安装脚本
- ⌨️ **按键映射** - 自动配置 Ctrl/Alt 交换和 CapsLock→Escape
- 💻 **开发工具** - Zsh、VSCode、Neovim 配置
- 📦 **Node.js 环境** - 使用 fnm 管理 Node 版本
- 🔧 **系统优化** - 自动修复文件限制问题

## 🚀 快速开始

```bash
git clone https://github.com/jiangxd2016/dotfiles.git
cd dotfiles
bash install.sh
```

安装脚本会自动：
1. 修复系统文件限制（解决 Node.js EMFILE 错误）
2. 安装 fnm 和 Node.js LTS
3. 配置按键映射
4. 安装 Zsh + Oh-My-Zsh + 插件
5. 链接 VSCode 配置文件

## 📁 项目结构

```
dotfiles/
├── install.sh              # 主安装脚本
├── helper.sh               # 平台检测工具
├── fix_limits.sh          # Linux 文件限制修复
├── fix-keys.sh            # Linux 按键映射
├── fnm-node.sh            # Node.js 安装
├── zsh.sh                 # Zsh 配置
├── vscode.sh              # VSCode 配置
├── nvim.sh                # Neovim 配置
├── mac/                   # macOS 专属配置
│   ├── karabiner/         # Karabiner-Elements 配置
│   ├── karabiner-keymap.sh
│   └── hammerspoon/       # Hammerspoon 配置
├── windows/               # Windows 专属配置
│   ├── setup-powertoys.ps1
│   └── README.md
└── vscode/                # VSCode 配置
    ├── linux/
    ├── mac/
    ├── windows/
    └── snippets/
```

## ⌨️ 按键映射

统一的按键方案适用于所有平台：

- **Left Ctrl ↔ Left Alt** (交换)
- **CapsLock → Escape**

### macOS

使用 [Karabiner-Elements](https://karabiner-elements.pqrs.org/)

```bash
# 安装 Karabiner
brew install --cask karabiner-elements

# 链接配置
bash mac/karabiner-keymap.sh
```

然后在 Karabiner-Elements 中启用 Complex Modifications。

### Linux

使用 XKB 选项（推荐方法）

```bash
sudo bash fix-keys.sh
```

配置会写入 `/etc/X11/xorg.conf.d/00-keyboard.conf`，重启 X 会话后生效。

### Windows

使用 [PowerToys](https://github.com/microsoft/PowerToys)

```powershell
# 安装 PowerToys
winget install Microsoft.PowerToys

# 配置按键映射
powershell -ExecutionPolicy Bypass -File windows/setup-powertoys.ps1
```

或者手动在 PowerToys 的 Keyboard Manager 中配置。

## 💻 VSCode 配置

自动切换输入法：

- **Windows/macOS**: 使用 [im-select](https://github.com/daipeihust/im-select)
- **Linux**: 使用 fcitx5 命令

配置文件按平台分离：
- `vscode/linux/` - Linux 专属设置
- `vscode/mac/` - macOS 专属设置
- `vscode/windows/` - Windows 专属设置
- `vscode/snippets/` - 通用代码片段

运行 `bash vscode.sh` 会自动链接对应平台的配置。

### Windows im-select 说明

> 默认配置：英文输入法为 1033，中文为 2052
> 
> - Windows 下必须安装英语键盘才能切换到英文输入法
> - im-select 默认复制到 D 盘（如无 D 盘则安装到用户目录）
> - 使用 `Ctrl+Shift` 切换键盘，`Shift` 切换输入法

## 🐚 Zsh 配置

支持 Linux 和 macOS（Windows 可使用 WSL）。

包含的插件：
- zsh-syntax-highlighting
- zsh-autosuggestions
- k (目录导航增强)
- git-open

配置文件：
- `.zshrc` - 主配置文件
- `.vsvimrc` - VS Code Vim 配置

## 📝 Neovim

跨平台统一配置，位于 `nvim/` 目录。

```bash
bash nvim.sh  # 安装配置
```

## 🔧 系统优化

### 修复 Node.js EMFILE 错误

当运行大型前端项目时，可能遇到 "Error: EMFILE: too many open files" 错误。

**Linux:**
```bash
bash fix_limits.sh
# 重启终端后验证
ulimit -n  # 应输出 65535
```

**macOS:**
```bash
# 已集成到 install.sh 中
sudo launchctl limit maxfiles 65535 200000
```

**Windows:**

Windows 不需要修改文件限制。如遇文件监听问题，在 VSCode 的 `settings.json` 中排除 node_modules：

```json
{
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/.git/objects/**": true
  }
}
```

## 📦 Node.js 环境

使用 [fnm](https://github.com/Schniz/fnm) (Fast Node Manager) 管理 Node.js 版本。

```bash
bash fnm-node.sh
```

会自动安装：
- fnm
- Node.js LTS
- 全局包：pnpm, taze, yarn, tsx, vitest

## 🛠️ 手动安装单个模块

如果只想安装特定部分：

```bash
bash zsh.sh         # 只安装 Zsh 配置
bash vscode.sh      # 只配置 VSCode
bash nvim.sh        # 只安装 Neovim 配置
bash fnm-node.sh    # 只安装 Node.js
```

## 📚 相关资源

- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) - macOS 键盘定制
- [PowerToys](https://github.com/microsoft/PowerToys) - Windows 系统工具
- [Oh My Zsh](https://ohmyz.sh/) - Zsh 框架
- [fnm](https://github.com/Schniz/fnm) - 快速的 Node 版本管理器
- [im-select](https://github.com/daipeihust/im-select) - 输入法切换工具

## 🐛 常见问题

### Q: 安装后按键映射没生效？

**macOS**: 打开 Karabiner-Elements，在 Complex Modifications 中启用配置  
**Linux**: 重启 X 会话或重启系统  
**Windows**: 重启计算机

### Q: VSCode 输入法切换不工作？

确保 im-select 已正确安装并在 PATH 中：

```bash
# 测试
im-select          # 应输出当前输入法
```

### Q: ulimit -n 仍然显示较小的值？

完全关闭终端窗口（或重启 VSCode），重新打开一个新终端。

## 📄 License

MIT

## 👤 Author

**jiangxd2016**

- GitHub: [@jiangxd2016](https://github.com/jiangxd2016)
