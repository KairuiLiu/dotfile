#!/bin/bash

# 检查是否提供了一个命令行参数
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <path-to-app-list.yaml>"
    exit 1
fi

# 从命令行参数获取 app-list.yaml 文件的路径
APP_LIST_PATH="$1"

# 解析 app-list.yaml 文件以获取备份应用列表，忽略以冒号结尾的名称
parseBackedApp() {
    local apps=()
    while IFS= read -r line; do
        if [[ "$line" == \#* ]] || [[ -z "$line" ]] || [[ "$line" == *":" ]]; then
            continue
        fi
        local software_name=$(echo "$line" | sed -e 's/^[[:space:]]*-\{1\}[[:space:]]*//' -e 's/\/\/.*//' -e 's/[[:space:]]*$//')
        apps+=("$software_name")
    done < "$APP_LIST_PATH"
    echo "${apps[*]}"
}

# 获取软件包的组
getGroups() {
    local software="$1"
    local groups
    groups=$(LC_ALL=C yay -Qi "$software" | grep "Groups" | cut -d: -f2 | sed 's/,/ /g' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr -d '\n')
    if [[ "$groups" == "None" ]]; then
        echo ""
    else
        echo "$groups"
    fi
}

# 获取已安装的包
getInstalledPackage() {
    yay -Qqe | tr '\n' ' '
}

# 生成差异
genDiff() {
    read -ra backedPackages <<< "$(parseBackedApp)"
    read -ra installedPackages <<< "$(getInstalledPackage)"
    declare -A installedGroups=()

    declare -a diffAdd=()
    declare -a diffRemove=()

    for p in "${installedPackages[@]}"; do
        if [[ " ${backedPackages[*]} " =~ " ${p} " ]]; then
            continue
        fi
        read -ra groups <<< "$(getGroups "$p")"
        local backedAsGroup=false
        for g in "${groups[@]}"; do
            if [[ " ${backedPackages[*]} " =~ " ${g} " ]]; then
                installedGroups["$g"]=1
                backedAsGroup=true
                break
            fi
        done
        if [[ "$backedAsGroup" = false ]]; then
            diffAdd+=("$p")
        fi
    done

    for p in "${backedPackages[@]}"; do
        if [[ " ${installedPackages[*]} " =~ " ${p} " ]] || [[ -n "${installedGroups[$p]}" ]]; then
            continue
        fi
        diffRemove+=("$p")
    done

    {
        echo "# In the System but not in the backup"
        for d in "${diffAdd[@]}"; do
            echo "+ $d"
        done
        echo "# In the backup but not in the System"
        for d in "${diffRemove[@]}"; do
            echo "- $d"
        done
    } > diff-app.txt
}

# 执行生成差异函数
genDiff
yay -Qqe > new-app-list.txt
