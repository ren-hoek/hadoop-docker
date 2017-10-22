#!/bin/bash
service ssh start
if [ ${HADOOP_MASTER} ]; then
	cd /opt/hadoop
	su hadoop -c "./sbin/start-dfs.sh"
	su hadoop -c "./sbin/start-yarn.sh"
	su hadoop -c "./bin/hdfs dfs -mkdir -p /user/hadoop"
	su hadoop -c "./bin/hdfs dfs -mkdir -p /user/hive"
	su hadoop -c "./bin/hdfs dfs -chown hive:hive /user/hive"
	su hadoop -c "./bin/hdfs dfs -mkdir /tmp"
	su hadoop -c "./bin/hdfs dfs -chmod 0777 /tmp"
	su hadoop -c "./bin/hdfs dfs -chown hive:hive /user/hive"
	su hadoop -c "./bin/hdfs dfs -mkdir -p /user/gavin"
	su hadoop -c "./bin/hdfs dfs -chown gavin:gavin /user/gavin"
fi

if [ ${ZOO_MY_ID} ]; then
	cd /opt/zookeeper
	su zookeeper -c 'echo "${ZOO_MY_ID:-1}" > "/var/lib/zookeeper/myid"'
	su zookeeper -c "bin/zkServer.sh start"
fi

if [ ${HIVE_METASTORE} ]; then
	cd /opt/hive
	service mysql start
	mysql < metastore.sql
	su hive -c 'bin/hive --service metastore &'
fi

if [ ${HIVE_SERVER} ]; then
	cd /opt/hive
	su hive -c 'bin/hive --service hiveserver2 &'
fi
cd /opt

while true; do sleep 100; done
