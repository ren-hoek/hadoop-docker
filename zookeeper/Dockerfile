FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get -y install openjdk-8-jdk wget

WORKDIR /opt
RUN wget http://mirror.ox.ac.uk/sites/rsync.apache.org/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz 
RUN tar xvzf zookeeper-3.4.10.tar.gz
RUN mv zookeeper-3.4.10 zookeeper
  
ADD config/zoo.cfg zookeeper/conf
ADD config/start-zoo.sh zookeeper

RUN useradd -d /opt/zookeeper zookeeper

RUN mkdir -p /var/lib/zookeeper
RUN chown -R zookeeper:zookeeper /var/lib/zookeeper
RUN chown -R zookeeper:zookeeper /opt/zookeeper

WORKDIR /opt/zookeeper
RUN chmod +x start-zoo.sh
EXPOSE 2181 2888 3888
CMD ["./start-zoo.sh"]
