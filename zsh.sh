#!/usr/bin/env bash
set -e # 有错误立即退出

# ============ 公共函数 ============
retry() {
  local max_attempts="$1"
  local delay="$2"
  local cmd="${@:3}"

  local attempt=1
  while true; do
    echo "[Retry] $attempt/$max_attempts: $cmd"
    if eval "$cmd"; then
      return 0
    fi

    if [ "$attempt" -ge "$max_attempts" ]; then
      echo "Error: command failed after $max_attempts attempts: $cmd" >&2
      return 1
    fi

    attempt=$((attempt + 1))
    sleep "$delay"
  done
}

cmd_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ============ 基础配置 ============
. "$PWD/helper.sh"

# 检测操作系统
os_type=$(detect_os)
echo "Detected OS: $os_type"

user_home=$(get_user_home)
echo "User home directory: $user_home"

MY_ZSH="$PWD/zsh"
ZSH_CUSTOM="$user_home/.oh-my-zsh/custom/plugins"

# ============ 安装 zsh 和 oh-my-zsh ============
if ! cmd_exists zsh; then
  echo "Installing zsh..."
  if [ "$(id -u)" -ne 0 ]; then
    sudo apt update
    sudo apt install -y zsh
  else
    apt update
    apt install -y zsh
  fi
fi

# 修改默认 shell 为 zsh
if [ "$(basename "$SHELL")" != "zsh" ]; then
  echo "Changing default shell to zsh..."
  echo "/usr/bin/zsh" | sudo tee -a /etc/shells
  chsh -s "$(command -v zsh)"
fi

# 安装 oh-my-zsh（如果不存在）
if [ ! -d "$user_home/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  # 使用官方脚本，但通过环境变量让它在脚本里安静一点
  # CHSH=no RUNZSH=no KEEP_ZSHRC=yes 可以按需调整
  # 参考：install.sh 支持 CHSH / RUNZSH / KEEP_ZSHRC 等环境变量
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "oh-my-zsh already installed, skipping..."
fi

# 确保 $ZSH_CUSTOM 目录存在
if [ ! -d "$ZSH_CUSTOM" ]; then
  mkdir -p "$ZSH_CUSTOM"
fi

# ============ 插件安装（带重试 & 幂等） ============
install_omz_plugin() {
  local repo_url="$1"
  local plugin_name="$2"

  if [ -d "$ZSH_CUSTOM/$plugin_name" ]; then
    echo "Plugin $plugin_name already exists, skipping clone."
    return 0
  fi

  echo "Installing plugin $plugin_name ..."
  retry 3 5 git clone --depth=1 "$repo_url" "$ZSH_CUSTOM/$plugin_name"
}

# zsh-syntax-highlighting
install_omz_plugin \
  https://github.com/zsh-users/zsh-syntax-highlighting.git \
  zsh-syntax-highlighting

# zsh-autosuggestions
install_omz_plugin \
  https://github.com/zsh-users/zsh-autosuggestions.git \
  zsh-autosuggestions

# k
install_omz_plugin \
  https://github.com/supercrabtree/k.git \
  k

# git-open
install_omz_plugin \
  https://github.com/paulirish/git-open.git \
  git-open

# ============ 软链接配置文件 ============
echo "Linking zsh config files..."

ln -sf "$MY_ZSH/.zshrc" "$user_home/.zshrc"

# 如果你确实有 ideavimrc / vsvimrc，可以按需打开
# ln -sf "$MY_ZSH/.ideavimrc"  "$user_home/.ideavimrc"
ln -sf "$MY_ZSH/.vsvimrc"  "$user_home/.vsvimrc"

# ============ macOS 特有：VSCode 按键重复 ============
if [ "$(uname -s)" = "Darwin" ]; then
  echo "Running macOS-specific tweaks..."

  # VSCode 按键重复（macOS）
  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false

  # 如果之前全局设置过，可以删除全局设置
  defaults delete -g ApplePressAndHoldEnabled 2>/dev/null || true
else
  echo "Not macOS, skipping VSCode ApplePressAndHoldEnabled tweaks."
fi

# ============ 提示用户 ============
echo
echo "All done. Please:"
echo "  1. Log out and log back in (or restart your terminal) to use zsh as default shell."
echo "  2. Open a new terminal and check: echo \$SHELL"
echo "  3. If you want to use the new config immediately in THIS terminal, run:"
echo "       source ~/.zshrc"
