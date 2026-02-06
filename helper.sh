#!/bin/sh

# get 
detect_os() {
    local uname_out="$(uname -s)"
    local os_type=""

    # check os type from uname
    case "$uname_out" in
        Linux*)     os_type="linux";;
        Darwin*)    os_type="mac";;
        CYGWIN*|MINGW*|MSYS*) os_type="windows";;
        *)          os_type="Unknown: $uname_out";;
    esac

    # check is windows from path
    if [ "$os_type" = "Unknown: $uname_out" ]; then
        if [ "$OS" = "Windows_NT" ]; then
            os_type="windows"
        elif [ -d "/windows" ]; then
            os_type="windows"
        fi
    fi

    echo $os_type
}


# get user home directory
get_user_home() {
    local home_dir os_type
    os_type=$(detect_os)
    if [ "$os_type" = "mac" ]; then
        home_dir="$HOME"
    elif [ "$os_type" = "linux" ]; then
        home_dir=$(getent passwd "$(logname 2>/dev/null || echo "${SUDO_USER:-$USER}")" | cut -d: -f6)
    elif [ "$os_type" = "windows" ]; then
        home_dir="$HOME"
    else
        echo "Unsupported OS. Cannot determine user home directory." >&2
        exit 1
    fi

    if [ -z "$home_dir" ]; then
        echo "错误：用户不存在或无法获取主目录" >&2
        exit 1
    fi
    echo "$home_dir"
}
