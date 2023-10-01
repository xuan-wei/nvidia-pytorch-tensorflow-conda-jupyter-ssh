#!/bin/sh
/usr/sbin/sshd -f ${HOME}/.local/my_sshd/sshd_config &
# code-server --host 0.0.0.0 --port 1000 & # if you need codeserver
bash -ic 'jupyter server --notebook-dir=${HOME} --ip 0.0.0.0 --no-browser --allow-root --port 8888'
