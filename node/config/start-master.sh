#!/bin/bash
service ssh start
if [ ${HADOOP_MASTER} ]; then
	cd /opt/hadoop
	su hadoop -c "./sbin/start-dfs.sh"
	su hadoop -c "./sbin/start-yarn.sh"
fi

if [ ${ZOO_MY_ID} ]; then
	cd /opt/zookeeper
	su zookeeper -c 'echo "${ZOO_MY_ID:-1}" > "/var/lib/zookeeper/myid"'
	su zookeeper -c "bin/zkServer.sh start"
fi

cd /opt

while true; do sleep 100; done
