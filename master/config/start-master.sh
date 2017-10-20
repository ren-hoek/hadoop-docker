#!/bin/bash
service ssh start
su hadoop -c "./sbin/start-dfs.sh"
su hadoop -c "./sbin/start-yarn.sh"
while true; do sleep 100; done
