FROM ubuntu:22.04

#sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list &&\
#sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list &&\

RUN mkdir -p /datax-job-runner &&\
    apt-get update &&\
    apt install ansible -y -q &&\
    apt install openjdk-8-jdk mysql-client vim pip -y -q &&\
    ansible-galaxy collection install community.mysql &&\
    pip install pymysql &&\
    apt-get clean &&\
    wget https://datax-opensource.oss-cn-hangzhou.aliyuncs.com/202309/datax.tar.gz && tar -zxf datax.tar.gz -C /datax-job-runner && rm -rf datax.tar.gz

WORKDIR /datax-job-runner
COPY . /datax-job-runner
