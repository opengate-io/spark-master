FROM bitnami/minideb-extras:jessie-r21
MAINTAINER DUONG Dinh Cuong <cuong3ihut@gmail.com>

ENV SPARK_VERSION 1.6.3
ENV HADOOP_VERSION 2.6

ENV SPARK_MASTER_HOME /opt
ENV SPARK_HOME=${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV PATH=${SPARK_HOME}/bin:$PATH

ENV SPARK_DRIVER_MEMORY 4G
ENV SPARK_EXECUTOR_MEMORY 8G

# Install required system packages and dependencies
RUN install_packages libc6 libffi6 libgcc1 libglib2.0-0 liblzma5 libpcre3 libselinux1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.144-0 --checksum 8b4315727f65780d8223df0aeaf5e3beca10a14aa4e2cdd1f3541ab50b346433
RUN mkdir -p ${SPARK_MASTER_HOME}/

RUN curl -O https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C ${SPARK_MASTER_HOME} \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
COPY files/spark-env.sh ${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/conf/spark-env.sh
RUN chmod +x ${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/sbin/start-master.sh

EXPOSE 8080 7077

CMD ${SPARK_MASTER_HOME}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/sbin/start-master.sh
