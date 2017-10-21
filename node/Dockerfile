FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get -y install openssh-server openjdk-8-jdk wget

# HDFS/YARN
RUN mkdir /opt/hadoop
RUN useradd -d /opt/hadoop hadoop
RUN chown -R hadoop:hadoop /opt/hadoop/
USER hadoop
WORKDIR /opt/hadoop

RUN wget http://mirror.ox.ac.uk/sites/rsync.apache.org/hadoop/common/hadoop-2.7.4/hadoop-2.7.4.tar.gz && \
    tar -xzvf hadoop-2.7.4.tar.gz && \
    cp -r hadoop-2.7.4/* . && \
    rm -rf hadoop-2.7.4 && \
    rm hadoop-2.7.4.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/opt/hadoop 
ENV PATH=$PATH:/opt/hadoop/bin:/opt/hadoop/sbin 

RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

# Zookeeper
USER root
RUN useradd -d /opt/zookeeper zookeeper

WORKDIR /opt
RUN wget http://mirror.ox.ac.uk/sites/rsync.apache.org/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz 
RUN tar xvzf zookeeper-3.4.10.tar.gz
RUN mv zookeeper-3.4.10 zookeeper

RUN mkdir -p /var/lib/zookeeper
RUN chown -R zookeeper:zookeeper /var/lib/zookeeper
RUN chown -R zookeeper:zookeeper /opt/zookeeper

COPY config/* /tmp/

USER root

RUN chown -R hadoop:hadoop /tmp/

RUN mv /tmp/ssh_config $HADOOP_HOME/.ssh/config && \ 
    mv /tmp/hadoop-env.sh /opt/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/start-hadoop.sh $HADOOP_HOME/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh $HADOOP_HOME/run-wordcount.sh && \
    mv /tmp/start-master.sh $HADOOP_HOME/start-master.sh && \
    mv /tmp/start-slave.sh $HADOOP_HOME/start-slave.sh

RUN chown -R root:root /tmp/

RUN chmod +x $HADOOP_HOME/start-hadoop.sh && \
    chmod +x $HADOOP_HOME/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x $HADOOP_HOME/start-master.sh && \
    chmod +x $HADOOP_HOME/start-slave.sh 

# format namenode
USER hadoop
RUN $HADOOP_HOME/bin/hdfs namenode -format
USER root
EXPOSE 8088 50070

ADD config/zoo.cfg zookeeper/conf
WORKDIR /opt/hadoop

CMD [ "./start-master.sh"]

