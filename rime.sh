#!/usr/bin/env bash
# ============================================================================
# 脚本名称：rime_optimized.sh
# 功能：智能安装和配置 Rime 输入法（支持 ibus-rime 和 fcitx5-rime）
# 使用方法：
#   chmod +x rime_optimized.sh
#   ./rime_optimized.sh [--local-config <path>]
#
# 选项：
#   --local-config <path>  使用本地已下载的 oh-my-rime 配置目录
#   --skip-install         跳过系统包安装（仅配置）
#   --framework <ibus|fcitx5>  指定输入法框架
# ============================================================================

set -euo pipefail

# -------------------- 配置 --------------------
OHMYRIME_REPO="https://github.com/Mintimate/oh-my-rime.git"
LOCAL_CONFIG_PATH=""
SKIP_INSTALL=false
FORCE_FRAMEWORK=""

# 正确的 Rime 配置目录
RIME_DIR_IBUS="$HOME/.config/ibus/rime"
RIME_DIR_FCT5="$HOME/.local/share/fcitx5/rime"

# -------------------- 颜色与日志 --------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_error()   { echo -e "${RED}[ERROR]${NC} $*"; }
log_hint()    { echo -e "${BLUE}[HINT]${NC}  $*"; }

# -------------------- 参数解析 --------------------
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --local-config)
        LOCAL_CONFIG_PATH="$2"
        shift 2
        ;;
      --skip-install)
        SKIP_INSTALL=true
        shift
        ;;
      --framework)
        FORCE_FRAMEWORK="$2"
        shift 2
        ;;
      -h|--help)
        echo "用法: $0 [选项]"
        echo "选项:"
        echo "  --local-config <path>   使用本地 oh-my-rime 配置目录"
        echo "  --skip-install          跳过系统包安装"
        echo "  --framework <ibus|fcitx5>  强制指定输入法框架"
        echo "  -h, --help              显示此帮助信息"
        exit 0
        ;;
      *)
        log_error "未知选项: $1"
        exit 1
        ;;
    esac
  done
}

# -------------------- 发行版检测 --------------------
detect_distro() {
  if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO_ID="${ID:-unknown}"
    DISTRO_LIKE="${ID_LIKE:-}"
    DISTRO_VERSION="${VERSION_ID:-0}"
  else
    DISTRO_ID="unknown"
    DISTRO_LIKE=""
    DISTRO_VERSION="0"
  fi

  # Deepin 特殊处理
  if [[ "$DISTRO_ID" == "deepin" ]] || [[ "$DISTRO_LIKE" == *"debian"* ]]; then
    DISTRO_FAMILY="debian"
  elif [[ "$DISTRO_ID" =~ ^(ubuntu|debian|linuxmint|pop)$ ]]; then
    DISTRO_FAMILY="debian"
  elif [[ "$DISTRO_ID" == "fedora" ]]; then
    DISTRO_FAMILY="fedora"
  elif [[ "$DISTRO_ID" =~ ^(arch|manjaro|endeavouros)$ ]]; then
    DISTRO_FAMILY="arch"
  else
    DISTRO_FAMILY="unknown"
  fi

  log_info "检测到系统：$DISTRO_ID (家族: $DISTRO_FAMILY, 版本: $DISTRO_VERSION)"
}

# -------------------- 输入法框架检测 --------------------
detect_im() {
  if [ -n "$FORCE_FRAMEWORK" ]; then
    IM_FRAMEWORK="$FORCE_FRAMEWORK"
    log_info "使用指定的输入法框架: $IM_FRAMEWORK"
    return
  fi

  # 优先检测 fcitx5
  if command -v fcitx5 >/dev/null 2>&1 || pgrep -x fcitx5 >/dev/null 2>&1; then
    IM_FRAMEWORK="fcitx5"
    log_info "检测到 fcitx5，将配置 fcitx5-rime"
    return
  fi

  # 检测 ibus
  if command -v ibus >/dev/null 2>&1 || pgrep -x ibus-daemon >/dev/null 2>&1; then
    IM_FRAMEWORK="ibus"
    log_info "检测到 ibus，将配置 ibus-rime"
    return
  fi

  # 未检测到，询问用户
  log_hint "未检测到运行中的输入法框架，请选择："
  echo "1) IBus（兼容性好，大多数桌面环境默认）"
  echo "2) Fcitx5（功能强大，推荐，支持薄荷输入法全部特性）"
  read -rp "请选择 [1/2]: " ans
  case "$ans" in
    1) IM_FRAMEWORK="ibus" ;;
    2) IM_FRAMEWORK="fcitx5" ;;
    *) log_error "无效选择"; exit 1 ;;
  esac
}

# -------------------- 包安装 --------------------
install_packages() {
  local needs_sudo=false

  # 检查是否需要 sudo
  if [ "$(id -u)" -ne 0 ]; then
    if ! command -v sudo >/dev/null 2>&1; then
      log_error "需要 sudo 权限来安装系统包，但未找到 sudo 命令"
      exit 1
    fi
    needs_sudo=true
  fi

  local sudo_cmd=""
  [ "$needs_sudo" = true ] && sudo_cmd="sudo"

  case "$DISTRO_FAMILY" in
    debian)
      log_info "更新包数据库..."
      $sudo_cmd apt-get update -qq

      if [ "$IM_FRAMEWORK" = "fcitx5" ]; then
        log_info "安装 fcitx5-rime 及相关组件..."
        $sudo_cmd apt-get install -y \
          fcitx5 \
          fcitx5-rime \
          fcitx5-chinese-addons \
          fcitx5-config-qt \
          librime-data \
          librime-plugin-lua 2>/dev/null || \
          log_warn "librime-plugin-lua 安装失败，部分功能可能受限"
      else
        log_info "安装 ibus-rime..."
        $sudo_cmd apt-get install -y ibus-rime
      fi
      ;;

    fedora)
      log_info "安装 Rime 输入法..."
      if [ "$IM_FRAMEWORK" = "fcitx5" ]; then
        $sudo_cmd dnf install -y fcitx5 fcitx5-rime fcitx5-configtool
      else
        $sudo_cmd dnf install -y ibus-rime
      fi
      ;;

    arch)
      log_info "安装 Rime 输入法..."
      if [ "$IM_FRAMEWORK" = "fcitx5" ]; then
        $sudo_cmd pacman -S --noconfirm fcitx5 fcitx5-rime fcitx5-chinese-addons fcitx5-configtool
      else
        $sudo_cmd pacman -S --noconfirm ibus-rime
      fi
      ;;

    *)
      log_warn "未知发行版，请手动安装 ${IM_FRAMEWORK}-rime"
      read -rp "是否继续配置？[y/N]: " continue_ans
      [[ "$continue_ans" != "y" ]] && exit 1
      ;;
  esac
}

# -------------------- 环境变量配置（fcitx5） --------------------
setup_fcitx5_env() {
  local env_file="$HOME/.xprofile"
  local env_content='# Fcitx5 输入法环境变量
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus'

  if grep -q "GTK_IM_MODULE.*fcitx" "$env_file" 2>/dev/null; then
    log_info "环境变量已存在于 $env_file"
  else
    log_info "写入 fcitx5 环境变量到 $env_file"
    echo "" >> "$env_file"
    echo "$env_content" >> "$env_file"
  fi

  log_hint "环境变量已配置，需要注销重新登录后生效"
}

# -------------------- 安装 Oh-my-rime 配置 --------------------
install_config() {
  local target_dir="$1"

  # 备份现有配置
  if [ -d "$target_dir" ] && [ "$(ls -A "$target_dir" 2>/dev/null)" ]; then
    local backup_dir="${target_dir}.backup.$(date +%Y%m%d_%H%M%S)"
    log_info "备份现有配置到: $backup_dir"
    cp -r "$target_dir" "$backup_dir"
  fi

  mkdir -p "$target_dir"

  local source_dir=""

  # 使用本地配置
  if [ -n "$LOCAL_CONFIG_PATH" ]; then
    if [ ! -d "$LOCAL_CONFIG_PATH" ]; then
      log_error "本地配置目录不存在: $LOCAL_CONFIG_PATH"
      exit 1
    fi
    source_dir="$LOCAL_CONFIG_PATH"
    log_info "使用本地配置: $source_dir"
  else
    # 从 Git 克隆
    if ! command -v git >/dev/null 2>&1; then
      log_error "需要 git 来克隆配置，请先安装 git"
      exit 1
    fi

    local tmp_dir
    tmp_dir=$(mktemp -d)
    log_info "克隆 oh-my-rime 配置..."

    if ! git clone --depth 1 "$OHMYRIME_REPO" "$tmp_dir"; then
      log_error "克隆失败，请检查网络连接"
      rm -rf "$tmp_dir"
      exit 1
    fi

    source_dir="$tmp_dir"
  fi

  # 复制配置文件
  log_info "复制配置文件到: $target_dir"

  # 复制 YAML 配置文件
  find "$source_dir" -maxdepth 1 -name "*.yaml" -exec cp {} "$target_dir/" \;

  # 复制 Lua 脚本
  [ -f "$source_dir/rime.lua" ] && cp "$source_dir/rime.lua" "$target_dir/"

  # 复制目录
  for dir in dicts lua opencc; do
    if [ -d "$source_dir/$dir" ]; then
      cp -r "$source_dir/$dir" "$target_dir/"
    fi
  done

  # 清理临时目录
  if [ -z "$LOCAL_CONFIG_PATH" ]; then
    rm -rf "$source_dir"
  fi

  log_info "配置文件已安装到: $target_dir"
}

# -------------------- 部署 Rime --------------------
deploy_rime() {
  local rime_dir="$1"

  log_info "清理旧的编译缓存..."
  rm -rf "${rime_dir}/build"

  if [ "$IM_FRAMEWORK" = "fcitx5" ]; then
    log_info "重启 fcitx5..."
    pkill -9 fcitx5 2>/dev/null || true
    sleep 1
    nohup fcitx5 >/dev/null 2>&1 &
    sleep 2
  else
    log_info "重启 ibus..."
    ibus restart >/dev/null 2>&1 || log_warn "ibus 重启失败，请手动重启"
  fi

  log_hint "请按 Ctrl+~ 或 F4 打开输入法菜单，选择"部署"来应用配置"
}

# -------------------- 主流程 --------------------
main() {
  parse_args "$@"

  log_info "=== Rime 输入法安装与配置脚本 ==="

  detect_distro
  detect_im

  # 设置配置目录
  if [ "$IM_FRAMEWORK" = "fcitx5" ]; then
    RIME_DIR="$RIME_DIR_FCT5"
  else
    RIME_DIR="$RIME_DIR_IBUS"
  fi

  log_info "配置目录: $RIME_DIR"

  # 安装系统包
  if [ "$SKIP_INSTALL" = false ]; then
    install_packages
  else
    log_info "跳过系统包安装"
  fi

  # 安装配置
  install_config "$RIME_DIR"

  # 配置环境变量（仅 fcitx5）
  if [ "$IM_FRAMEWORK" = "fcitx5" ]; then
    setup_fcitx5_env
  fi

  # 部署
  deploy_rime "$RIME_DIR"

  log_info "=== 安装完成 ==="
  echo ""
  log_hint "接下来的步骤："

  if [ "$IM_FRAMEWORK" = "fcitx5" ]; then
    echo "1. 注销并重新登录（或重启）以使环境变量生效"
    echo "2. 确保 fcitx5 正在运行（可以运行: fcitx5 &）"
    echo "3. 按 Ctrl+~ 调出输入法菜单，选择"部署""
    echo "4. 部署完成后，再次按 Ctrl+~ 选择输入方案（推荐：薄荷拼音）"
    echo ""
    echo "配置工具: fcitx5-configtool"
  else
    echo "1. 重启 ibus: ibus restart"
    echo "2. 在系统设置 -> 输入法中添加"中州韵 (Rime)""
    echo "3. 按 Ctrl+~ 调出输入法菜单，选择"部署""
    echo "4. 部署完成后选择你喜欢的输入方案"
  fi

  echo ""
  log_info "词库位置: $RIME_DIR"
  log_info "更多信息: https://github.com/Mintimate/oh-my-rime"
}

main "$@"
