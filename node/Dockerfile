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
ENV PATH="${PATH}:/opt/hadoop/bin:/opt/hadoop/sbin" 

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
RUN rm zookeeper-3.4.10.tar.gz

RUN mkdir -p /var/lib/zookeeper
RUN chown -R zookeeper:zookeeper /var/lib/zookeeper
RUN chown -R zookeeper:zookeeper /opt/zookeeper

# Hive
USER root
RUN useradd -d /opt/hive hive

WORKDIR /opt
RUN wget http://mirror.ox.ac.uk/sites/rsync.apache.org/hive/hive-2.1.1/apache-hive-2.1.1-bin.tar.gz
RUN tar xvzf apache-hive-2.1.1-bin.tar.gz
RUN mv apache-hive-2.1.1-bin hive
RUN rm apache-hive-2.1.1-bin.tar.gz

WORKDIR /opt/hive
USER hive
ENV HIVE_HOME=/opt/hive
ENV PATH="${PATH}:$HIVE_HOME/bin" 

USER root
# Hive metastore
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -q -y install mysql-server libmysql-java

# Configuration
WORKDIR /opt
USER root
COPY config/* /tmp/

RUN chown -R hadoop:hadoop /tmp/

RUN mv /tmp/ssh_config $HADOOP_HOME/.ssh/config && \ 
    mv /tmp/hadoop-env.sh /opt/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/run-wordcount.sh $HADOOP_HOME/run-wordcount.sh && \
    mv /tmp/start-node.sh $HADOOP_HOME/start-node.sh && \
    cp /tmp/.bashrc $HADOOP_HOME/.bashrc

RUN chown -R root:root /tmp/

RUN chmod +x $HADOOP_HOME/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x $HADOOP_HOME/start-node.sh 

RUN chown -R hive:hive $HIVE_HOME

# format namenode
USER hadoop
RUN $HADOOP_HOME/bin/hdfs namenode -format

EXPOSE 8088 50070

# Zookeeper config
USER zookeeper
ADD config/zoo.cfg zookeeper/conf
RUN cp /tmp/.bashrc /opt/zookeeper/.bashrc

EXPOSE 2181 2888 3888

#Set up hive metastore
USER hive
WORKDIR /opt/hive
RUN cp /tmp/.bashrc $HIVE_HOME/.bashrc && \
    cp /tmp/metastore.sql $HIVE_HOME/metastore.sql && \
    cp /tmp/hive-site.xml $HIVE_HOME/conf/hive-site.xml
RUN ln -s /usr/share/java/libmysql-java.jar /opt/hive/lib/libmysql-java.jar

COPY mysql-connector-java-5.1.44.tar.gz .
RUN tar xvzf mysql-connector-java-5.1.44.tar.gz
RUN cp mysql-connector-java-5.1.44/mysql-connector-java-5.1.44-bin.jar /opt/hive/lib
RUN cp /tmp/hive-schema-2.1.0.mysql.sql /opt/hive/scripts/metastore/upgrade/mysql

USER root
EXPOSE 9083 10000

WORKDIR /opt/hadoop
CMD [ "./start-node.sh"]

