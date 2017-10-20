##hadoop-docker

A 3 node hadoop cluster with a namenode and 2 datanodes
Based on https://github.com/kiwenlau/hadoop-cluster-docker
Uses docker-compose install with

```bash
pip install docker-compose
```

### Setup
To build and run the cluster
```bash
git clone git@github.com:ren-hoek/hadoop-docker.git
cd master
docker build -t hadoop/master .
cd ../slave
docker build -t hadoop/slave .
cd ..
docker-compose up -d
```
