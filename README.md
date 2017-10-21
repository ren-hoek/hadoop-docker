## hadoop-docker

A 3 node hadoop cluster with a namenode and 2 datanodes
Based on https://github.com/kiwenlau/hadoop-cluster-docker
Uses docker-compose install with

```bash
pip install docker-compose
```

### Setup
To build and run the cluster services

```bash
git clone git@github.com:ren-hoek/hadoop-docker.git
```

#### HDFS/Yarn
```bash
cd hdfs
./build.sh
docker-compose up -d
```

#### Zookeeper
```bash
cd zookeeper
./build.sh
docker-compose up -d
```

#### All services 
```bash
cd node
./build.sh
docker-compose up -d
```
