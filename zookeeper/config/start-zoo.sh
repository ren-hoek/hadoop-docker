#!/bin/bash
if [ ! -f "/var/lib/zookeeper/myid" ]; then
	echo "${ZOO_MY_ID:-1}" > "/var/lib/zookeeper/myid"
fi
su zookeeper -c "bin/zkServer.sh start"
while true; do sleep 100; done

