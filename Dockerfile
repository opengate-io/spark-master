FROM ubuntu
MAINTAINER DUONG Dinh Cuong <cuong3ihut@gmail.com>

ENV SPARK_VERSION 1.6.3
ENV HADOOP_VERSION 2.6

ENV SPARK_MASTER_HOME /opt
ENV SPARK_HOME=${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=${SPARK_HOME}/bin:$PATH

ENV SPARK_DRIVER_MEMORY 4G
ENV SPARK_EXECUTOR_MEMORY 8G

RUN apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl wget openjdk-8-jdk libgfortran3 python-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p ${SPARK_MASTER_HOME}/

RUN curl -O https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C ${SPARK_MASTER_HOME} \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
COPY files/spark-env.sh ${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/conf/spark-env.sh
COPY files/spark-daemon.sh ${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/sbin/spark-daemon.sh
RUN chmod +x ${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/sbin/start-master.sh \
    && chmod +x ${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/sbin/spark-daemon.sh

EXPOSE 8080 7077

CMD ${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/sbin/start-master.sh
