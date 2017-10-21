#!/bin/bash
service ssh start
if [ ${HADOOP_MASTER} ]; then
	cd /opt/hadoop
	su hadoop -c "./sbin/start-dfs.sh"
	su hadoop -c "./sbin/start-yarn.sh"
fi

cd /opt

while true; do sleep 100; done
