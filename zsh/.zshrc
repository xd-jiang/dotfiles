

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
ZSH_DISABLE_COMPFIX="true"


plugins=(
  git
  zsh-autosuggestions
  z
  k
  git-open
  zsh-syntax-highlighting
)

[ -s "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# alias
alias v='nvim'

alias ni="pnpm i"
alias nio="pnpm i --prefer-offline"
alias nr="pnpm run"
alias nd="pnpm run dev"
alias nb="pnpm run build"
alias ns="pnpm run serve"

alias nwd="pnpm run -w dev"
alias nwb="pnpm run -w build"
alias nws="pnpm run -w serve"

alias ndd="npm run docs:dev"
alias ndb="npm run docs:build"
alias nds="npm run docs:serve"

alias nt="pnpm run test"
alias ntw="pnpm run test:watch"
alias pw="pnpm why"
alias pr="pnpm -r"

alias nw="pnpm watch"
alias np="pnpm run play"
alias nc="pnpm run clean"
alias ntc="pnpm run typecheck"
alias nl="pnpm run lint"
alias nlf="pnpm run lint --fix"
alias ne="pnpm run release"

alias ra="rm -rf node_modules pnpm-lock.yaml yarn.lock package-lock.json yarn-error.json"

alias cls="clear && printf '\e[3J'"
alias ll="ls -la"
alias gz="tar -zxvf"
alias cp="cp -i"
alias mvim='mvim -v'
alias cz="pnpm run cz"
alias ga="git add"
alias gd="git diff"
alias gf="git fetch"
alias gp="git push"
alias gs="git status"
alias gc="git commit -m"
alias gac="git add . && git commit -m" # + commit message
alias gco="git checkout"
alias gk="git checkout ."
alias hp="hexo clean && hexo g && hexo d"
alias gacp="git add . && git commit -m 'update' && git push"
alias aga="alias | grep git" # all git command abbreviations
alias glt="git log --date format:'%Y-%m-%d %H:%M:%S'"
alias ip="ifconfig en0 inet | grep inet | awk '{ print \$2 }'"

alias python='python3'

# customer directory
alias www="$HOME/Documents/www"
alias work="$HOME/Documents/work"
alias dep="$HOME/Documents/dep"



#创建git tag
tag() {
  local tagname detail
  echo "请输入tagname:"
  read -r tagname
  if [ -z "$tagname" ]; then
    echo "输入的tagname为空"
    return 1
  fi

  echo "请输入描述:"

  read -r detail
  if [ -z "$detail" ]; then
    detail="say nothing"
  fi

  git tag -a "$tagname" -m "$detail"
}


# 自动生成.gitignore
ignore() {
  if [ -f ".gitignore" ]; then
    echo "gitignore已存在"
    return
  fi
  echo "...正在生成.gitignore"
  cat > .gitignore <<'EOF'
*.DS_Store
node_modules
*.log
idea/
*.local
.DS_Store
dist
.cache
.idea
logs
*-debug.log
*-error.log
EOF
}

# template
tvue() {
  if [ -z "${1:-}" ]; then
    echo "请输入模板名称"
    return 0
  fi
  echo "正在创建$1目录,下载starter-vue模板,请稍等..."
  if [ -z "${2:-}" ]; then
    pnpx degit jiangxd2016/starter-vue "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio
  else
    pnpx degit jiangxd2016/starter-vue "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio || nio || nio || echo '安装依赖失败，请重新尝试' && echo "正在执行 nr $2" && nr "$2" || eval "$2"
  fi
}
tvue-lib() {
  if [ -z "${1:-}" ]; then
    echo "请输入模板名称"
    return 0
  fi
  echo "正在创建$1目录,下载starter-vue模板,请稍等..."
  if [ -z "${2:-}" ]; then
    pnpx degit jiangxd2016/starter-vue-lib "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio
  else
    pnpx degit jiangxd2016/starter-vue-lib "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio || nio || nio || echo '安装依赖失败，请重新尝试' && echo "正在执行 nr $2" && nr "$2" || eval "$2"
  fi
}
tts() {
  if [ -z "${1:-}" ]; then
    echo "请输入模板名称"
    return 0
  fi
  echo "正在创建$1目录,下载starter-ts模板,请稍等..."
  if [ -z "${2:-}" ]; then
    pnpx degit jiangxd2016/starter-ts "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio
  else
    pnpx degit jiangxd2016/starter-ts "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio || nio || nio || echo '安装依赖失败，请重新尝试' && echo "正在执行 nr $2" && nr "$2" || eval "$2"
  fi
}
tre() {
  if [ -z "${1:-}" ]; then
    echo "请输入模板名称"
    return 0
  fi
  echo "正在创建$1目录,下载starter-react模板,请稍等..."
  if [ -z "${2:-}" ]; then
    pnpx degit jiangxd2016/starter-react "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio
  else
    pnpx degit jiangxd2016/starter-react "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio || nio || nio || echo '安装依赖失败，请重新尝试' && echo "正在执行 nr $2" && nr "$2" || eval "$2"
  fi
}
tmo() {
  if [ -z "${1:-}" ]; then
    echo "请输入模板名称"
    return 0
  fi
  echo "正在创建$1目录,下载starter-monorepo模板,请稍等..."
  if [ -z "${2:-}" ]; then
    pnpx degit jiangxd2016/starter-monorepo "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio
  else
    pnpx degit jiangxd2016/starter-monorepo "$1" && echo "正在打开$1" && code "$1" && cd "$1" && echo '正在下载依赖' && nio || nio || nio || echo '安装依赖失败，请重新尝试' && echo "正在执行 nr $2" && nr "$2" || eval "$2"
  fi
}

# export PATH="/usr/local/opt/node@18/bin:$PATH"
# export PATH="/usr/local/opt/openjdk/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# bind auto key
# bindkey '^E' autosuggest-accept
# bindkey '^H' autosuggest-clear


# rust proxy
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


export PATH="$HOME/.local/bin:$PATH"

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# fnm
FNM_PATH="/home/ziyang/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi
