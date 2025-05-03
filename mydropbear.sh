#!/bin/sh
cat /mnt/onboard/.adds/koreader/plugins/terminal.koplugin/profile | grep PATH
PATH="${PATH}:${TERMINAL_DATA}/scripts:${TERMINAL_HOME}/plugins/terminal.koplugin/"
export PATH=$PATH:/mnt/onboard/.adds/koreader/scripts
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/onboard/.adds/koreader/libs
export HOME=/mnt/onboard/.adds/koreader/
cd $HOME
dropbear -E -R -p2222 -P /tmp/dropbear_koreader.pid
