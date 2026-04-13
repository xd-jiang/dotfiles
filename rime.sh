#!/usr/bin/env bash
# ============================================================================
# 脚本名称：install_rime_with_ohmyrime.sh
# 功能：根据不同发行版自动安装 Rime（ibus-rime 或 fcitx5-rime），
#       并从 mintimate.cc 的 Oh-my-rime 仓库拉取配置模板。
# 使用方法：
#   chmod +x install_rime_with_ohmyrime.sh
#   sudo ./install_rime_with_ohmyrime.sh
#   或：sudo bash install_rime_with_ohmyrime.sh
# 注意：
#   - 本脚本会自动识别发行版，并使用对应包管理器安装 Rime。
#   - 如果你当前使用 ibus，脚本会安装 ibus-rime；如果使用 fcitx5，会安装 fcitx5-rime。
#   - 脚本会尝试写入 fcitx5 的环境变量到 ~/.xprofile 与 /etc/environment，
#     请根据实际情况重启 X/Wayland 会话或重新登录以生效。
#   - Oh-my-rime 配置来自 mintimate.cc 提供的仓库。
# ============================================================================

set -euo pipefail

# -------------------- 基础信息 --------------------
OHMYRIME_REPO="https://github.com/Mintimate/oh-my-rime.git"

# Rime 配置目录（根据实际使用的框架选择）
RIME_DIR_IBUS="$HOME/.config/ibus/rime"
RIME_DIR_FCT5="$HOME/.config/fcitx5/rime"

# -------------------- 颜色与日志 --------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*"; }
log_hint()    { echo -e "${BLUE}[HINT]${NC}  $*"; }

need_root() {
  if [ "$(id -u)" -ne 0 ]; then
    log_error "请使用 root 或 sudo 执行本脚本。"
    exit 1
  fi
}

# -------------------- 发行版检测 --------------------
detect_distro() {
  if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO_ID="${ID:-}"
    DISTRO_LIKE="${ID_LIKE:-}"
    DISTRO_VERSION="${VERSION_ID:-}"
  else
    DISTRO_ID="unknown"
    DISTRO_LIKE=""
    DISTRO_VERSION="0"
  fi
  log_info "检测到系统：DISTRO_ID=$DISTRO_ID, DISTRO_LIKE=$DISTRO_LIKE, VERSION_ID=$DISTRO_VERSION"
}

# -------------------- 包管理器抽象 --------------------
update_pkg_db() {
  case "$DISTRO_ID" in
    ubuntu|debian|linuxmint|pop)
      apt-get update -y
      ;;
    fedora)
      dnf makecache -y
      ;;
    arch|manjaro|endeavouros)
      pacman -Sy --noconfirm || true
      ;;
    *)
      log_warn "未知发行版 $DISTRO_ID，尝试按 Debian/Ubuntu 处理。"
      apt-get update -y || true
      ;;
  esac
}

install_pkg() {
  local pkgs=("$@")
  case "$DISTRO_ID" in
    ubuntu|debian|linuxmint|pop)
      apt-get install -y "${pkgs[@]}"
      ;;
    fedora)
      dnf install -y "${pkgs[@]}"
      ;;
    arch|manjaro|endeavouros)
      pacman -S --noconfirm "${pkgs[@]}"
      ;;
    *)
      log_warn "未知发行版 $DISTRO_ID，尝试使用 apt-get 安装。"
      apt-get install -y "${pkgs[@]}" || true
      ;;
  esac
}

# -------------------- 输入法框架检测 --------------------
detect_im() {
  # 优先检测 fcitx5 进程 / 环境变量
  if command -v fcitx5 >/dev/null 2>&1 || pgrep -u "$(id -u)" fcitx5 >/dev/null 2>&1; then
    IM_FRAMEWORK="fcitx5"
    log_info "检测到 fcitx5 已运行或已安装，将安装 fcitx5-rime 版本。"
    return
  fi

  # 其次检测 ibus
  if command -v ibus >/dev/null 2>&1 || pgrep -u "$(id -u)" ibus >/dev/null 2>&1; then
    IM_FRAMEWORK="ibus"
    log_info "检测到 IBus 已运行或已安装，将安装 ibus-rime 版本。"
    return
  fi

  # 若都检测不到，则询问用户
  log_hint "未检测到运行中的输入法框架。请选择要使用的框架（输入数字）："
  echo "1) IBus + ibus-rime（常见默认，兼容性好）"
  echo "2) Fcitx5 + fcitx5-rime（功能更强，配置灵活，Oh-my-rime 推荐方式）"
  read -r -p "请选择 [1/2]: " ans
  case "$ans" in
    1) IM_FRAMEWORK="ibus"; ;;
    2) IM_FRAMEWORK="fcitx5"; ;;
    *) log_error "无效选择，退出。"; exit 1; ;;
  esac
}

# -------------------- Rime 安装（ibus 版本） --------------------
install_ibus_rime() {
  log_info "开始安装 ibus-rime ..."
  case "$DISTRO_ID" in
    ubuntu|debian|linuxmint|pop)
      install_pkg ibus-rime
      ;;
    fedora)
      # Fedora 官方文档示例：sudo dnf install ibus-rime -y
      install_pkg ibus-rime
      ;;
    arch|manjaro|endeavouros)
      install_pkg ibus-rime
      ;;
    *)
      # 默认尝试 ibus-rime
      install_pkg ibus-rime || true
      ;;
  esac

  # 设置 ibus 为默认输入法（如果当前用户环境允许）
  if command -v im-config >/dev/null 2>&1; then
    log_info "尝试使用 im-config 将 IBus 设置为默认输入法框架。"
    im-config -n ibus || log_warn "im-config 设置失败，可手动执行：im-config -n ibus"
  fi

  log_info "建议执行：ibus restart；并在系统设置中添加“汉语 - Rime”输入法。"
  RIME_DIR="$RIME_DIR_IBUS"
}

# -------------------- Rime 安装（fcitx5 版本） --------------------
install_fcitx5_rime() {
  log_info "开始安装 fcitx5-rime（含中文支持与 librime-lua 插件）。"
  case "$DISTRO_ID" in
    ubuntu|debian|linuxmint|pop)
      # 参考 mintimate.cc 文档：安装 fcitx5 fcitx5-chinese-addons librime-plugin-lua；再安装 fcitx5-rime
      install_pkg fcitx5 fcitx5-chinese-addons fcitx5-config-qt
      # 尝试安装 librime-lua 插件（包名可能因发行版而异）
      if apt-cache show librime-plugin-lua >/dev/null 2>&1; then
        install_pkg librime-plugin-lua
      elif apt-cache show librime-lua >/dev/null 2>&1; then
        install_pkg librime-lua
      else
        log_warn "未找到 librime-plugin-lua/librime-lua，Oh-my-rime 的部分高级功能可能受限。"
      fi
      install_pkg fcitx5-rime
      ;;
    fedora)
      # Fedora 示例：安装 fcitx5 fcitx5-rime fcitx5-configtool 等
      install_pkg fcitx5 fcitx5-rime fcitx5-configtool
      # 若存在 librime-lua 插件包，也一并安装
      if dnf list librime-plugin-lua >/dev/null 2>&1; then
        install_pkg librime-plugin-lua
      else
        log_warn "Fedora 上未检测到 librime-plugin-lua，可参考文档手动编译 librime（支持 Lua）。"
      fi
      ;;
    arch|manjaro|endeavouros)
      # ArchWiki 推荐安装 fcitx5 fcitx5-chinese-addons fcitx5-im fcitx5-configtool fcitx5-rime
      install_pkg fcitx5 fcitx5-chinese-addons fcitx5-im fcitx5-configtool fcitx5-rime
      # 尝试安装 librime-lua（AUR 或官方仓库）
      if pacman -Si librime-lua >/dev/null 2>&1; then
        install_pkg librime-lua
      elif command -v yay >/dev/null 2>&1; then
        log_info "尝试使用 yay 从 AUR 安装 librime-lua ..."
        yay -S --noconfirm librime-lua || log_warn "AUR 安装 librime-lua 失败。"
      else
        log_warn "未找到 librime-lua 包，Oh-my-rime 的高级功能可能受限。"
      fi
      ;;
    *)
      log_warn "未知发行版，尝试按 fcitx5 常见安装方式处理。"
      install_pkg fcitx5 fcitx5-chinese-addons fcitx5-rime || true
      ;;
  esac

  # 设置 fcitx5 为默认输入法框架（如果可用）
  if command -v im-config >/dev/null 2>&1; then
    log_info "尝试使用 im-config 将 Fcitx5 设置为默认输入法框架。"
    im-config -n fcitx5 || log_warn "im-config 设置失败，可手动执行：im-config -n fcitx5"
  fi

  # 写入环境变量（按 mintimate.cc 文档建议）
  log_info "为 Fcitx5 写入输入法环境变量（GTK_IM_MODULE/QT_IM_MODULE/XMODIFIERS）。"
  local env_content
  env_content=$(
    cat <<'EOF'
# Fcitx5 input method framework (Rime)
export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=@im=fcitx5
EOF
  )

  # 用户级 .xprofile
  if [ -f "$HOME/.xprofile" ]; then
    log_warn "$HOME/.xprofile 已存在，为避免冲突，请手动合并以下环境变量："
    echo "---"
    echo "$env_content"
    echo "---"
  else
    echo "$env_content" >> "$HOME/.xprofile"
    log_info "已写入 $HOME/.xprofile（X 会话登录时生效）。"
  fi

  # 系统级 /etc/environment（需要 root）
  if [ -f /etc/environment ]; then
    if grep -q "GTK_IM_MODULE" /etc/environment || grep -q "fcitx5" /etc/environment; then
      log_warn "/etc/environment 已包含 IM 相关配置，为避免冲突，请手动确认："
      echo "---"
      echo "$env_content"
      echo "---"
    else
      echo "$env_content" >> /etc/environment
      log_info "已写入 /etc/environment（系统重启后生效）。"
    fi
  else
    log_warn "未找到 /etc/environment，跳过系统级环境变量写入。"
  fi

  log_info "建议：重启图形会话或重新登录，以确保 Fcitx5 与环境变量生效。"
  RIME_DIR="$RIME_DIR_FCT5"
}

# -------------------- 安装 git 并拉取 Oh-my-rime 配置 --------------------
install_ohmyrime_config() {
  local target_dir="$1" # 例如：~/.config/fcitx5/rime 或 ~/.config/ibus/rime

  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
    log_info "创建 Rime 配置目录：$target_dir"
  fi

  if ! command -v git >/dev/null 2>&1; then
    log_info "安装 git 以便拉取 Oh-my-rime 配置模板 ..."
    install_pkg git
  fi

  log_info "从 Oh-my-rime 仓库克隆配置模板到临时目录 ..."
  local tmp_repo
  tmp_repo=$(mktemp -d)
  git clone --depth 1 "$OHMYRIME_REPO" "$tmp_repo" || {
    log_error "克隆 Oh-my-rime 仓库失败，请检查网络或仓库地址：$OHMYRIME_REPO"
    rm -rf "$tmp_repo"
    return 1
  }

  log_info "将 Oh-my-rime 配置模板复制到 Rime 配置目录：$target_dir"
  # 只复制配置相关的文件/目录，避免覆盖 git 信息
  if [ -d "$tmp_repo/rime" ]; then
    cp -r "$tmp_repo/rime/." "$target_dir/"
  else
    # 若仓库根目录本身就是 Rime 配置目录结构，则直接复制
    cp -r "$tmp_repo/." "$target_dir/"
  fi

  # 清理临时目录
  rm -rf "$tmp_repo"

  log_info "Oh-my-rime 配置已复制到：$target_dir"
  log_hint "请在输入法配置中点击“重新部署（Deploy）”以应用新配置。"
}

# -------------------- 主流程 --------------------
main() {
  need_root
  detect_distro
  detect_im

  update_pkg_db

  case "$IM_FRAMEWORK" in
    ibus)
      install_ibus_rime
      ;;
    fcitx5)
      install_fcitx5_rime
      ;;
    *)
      log_error "不支持的输入法框架：$IM_FRAMEWORK（仅支持 ibus/fcitx5）。"
      exit 1
      ;;
  esac

  # 如果脚本在非 root 下运行（实际不建议），需要 chown
  if [ -n "${SUDO_USER:-}" ] && [ -d "${RIME_DIR:-}" ]; then
    chown -R "$SUDO_USER:$SUDO_USER" "$RIME_DIR"
  fi

  log_info "开始安装 Oh-my-rime 配置模板（mintimate.cc 提供）到 Rime 目录：$RIME_DIR"
  install_ohmyrime_config "$RIME_DIR"

  # 后续提示
  log_hint "安装与配置步骤已全部完成。接下来建议："
  case "$IM_FRAMEWORK" in
    ibus)
      echo "1) 执行：ibus restart（或重新登录）"
      echo "2) 在系统设置 -> 输入法中添加“汉语 - Rime”"
      ;;
    fcitx5)
      echo "1) 重新登录或重启图形会话（确保环境变量生效）"
      echo "2) 启动 Fcitx5（ fcitx5 & ）"
      echo "3) 在 Fcitx5 配置中添加“中州韵 (Rime)”"
      ;;
  esac
  log_hint "更多配置说明（方案切换、Emoji、双拼等）请参考 mintimate.cc 的 Oh-my-rime 文档。"
}

main "$@"
