# 常用脚本仓库

<!--ts-->
* [常用脚本仓库](#常用脚本仓库)
   * [镜像源](#镜像源)
      * [系统镜像源](#系统镜像源)
      * [docker 镜像源](#docker-镜像源)
   * [安装脚本](#安装脚本)
      * [docker](#docker)
      * [oh-my-zsh](#oh-my-zsh)
   * [测速速度](#测速速度)
      * [系统镜像源](#系统镜像源-1)
      * [docker 镜像源](#docker-镜像源-1)
<!--te-->

## 镜像源

### 系统镜像源

```bash
curl -sSL https://linuxmirrors.cn/main.sh | bash -s -- \
  --source mirrors.tuna.tsinghua.edu.cn \
  --web-protocol http \
  --intranet false \
  --install-epel true \
  --close-firewall false \
  --backup true \
  --updata-software true \
  --clean-cache false \
  --ignore-backup-tips
```

<details><summary>参数说明</summary>
<p>

| 名称                   | 含义                                            | 选项值            |
| ---------------------- | ----------------------------------------------- | ----------------- |
| `--source`             | 指定软件源地址                                  | 地址              |
| `--source-security`    | 指定 debian 的 security 软件源地址              | 地址              |
| `--source-vault`       | 指定 centos/almalinux 的 vault 软件源地址       | 地址              |
| `--branch`             | 指定软件源分支(路径)                            | 分支名            |
| `--branch-security`    | 指定 debian 的 security 软件源分支(路径)        | 分支名            |
| `--branch-vault`       | 指定 centos/almalinux 的 vault 软件源分支(路径) | 分支名            |
| `--abroad`             | 使用海外软件源                                  | 无                |
| `--abroad`             | 使用中国大陆教育网软件源                        | 无                |
| `--web-protocol`       | 指定 WEB 协议                                   | `http` 或 `https` |
| `--intranet`           | 优先使用内网地址                                | `true` 或 `false` |
| `--install-epel`       | 安装 EPEL 附加软件包                            | `true` 或 `false` |
| `--only-epel`          | 仅更换 EPEL 软件源模式                          | 无                |
| `--close-firewall`     | 关闭防火墙                                      | `true` 或 `false` |
| `--backup`             | 备份原有软件源                                  | `true` 或 `false` |
| `--ignore-backup-tips` | 忽略覆盖备份提示（即不覆盖备份）                | 无                |
| `--updata-software`    | 更新软件包                                      | `true` 或 `false` |
| `--clean-cache`        | 清理下载缓存                                    | `true` 或 `false` |
| `--print-diff`         | 打印源文件修改前后差异                          | `true` 或 `false` |
| `--help`               | 查看帮助菜单                                    | 无                |

</p>
</details>

### docker 镜像源

## 安装脚本

安装脚本会自动根据服务器的 IP 地址，选择合适的镜像源。

### docker

国外服务器：
```bash
curl -sSL https://github.com/zhaojun1998/script/blob/main/docker-install.sh | bash
```

国内服务器：
```bash
curl -sSL https://ghproxy.com/github.com/zhaojun1998/script/blob/main/docker-install.sh | bash
```

### oh-my-zsh

国外服务器：
```bash
curl -sSL https://github.com/zhaojun1998/script/blob/main/zsh-install.sh | bash
```

国内服务器：
```bash
curl -sSL https://ghproxy.com/github.com/zhaojun1998/script/blob/main/zsh-install.sh | bash
```

## 测速速度

### 系统镜像源

国外服务器：
```bash
curl -sSL https://github.com/zhaojun1998/script/blob/main/test/docker_hub_speed_test.sh | bash
```

国内服务器：
```bash
curl -sSL https://ghproxy.com/github.com/zhaojun1998/script/blob/main/test/docker_hub_speed_test.sh | bash
```

### docker 镜像源

国外服务器：
```bash
curl -sSL https://github.com/zhaojun1998/script/blob/main/test/os_repo_speed_test.sh | bash
```

国内服务器：
```bash
curl -sSL https://ghproxy.com/github.com/zhaojun1998/script/blob/main/test/os_repo_speed_test.sh | bash
```
