#!/bin/sh
# 启动 sshd 在后台
/usr/sbin/sshd -f "${HOME}/.local/my_sshd/sshd_config" &

# 保持容器不退出
tail -f /dev/null

