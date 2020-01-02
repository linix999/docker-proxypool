From ubuntu:18.04

MAINTAINER linix

ENV DEBIAN_FRONTEND noninteractive

# Set time zone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    git \
    vim \
    python3 \
    python3-pip \
    supervisor \
    curl \
    erlang-nox \
    rabbitmq-server \
    pwgen && rm -rf /var/lib/apt/lists/*

# supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/

#django config
ADD IPPoolManager.tar.xz /Work/
WORKDIR /Work/IPPoolManager/
ADD requirements.txt /Work/IPPoolManager/
RUN pip3 install -r requirements.txt

#celeryd user
RUN adduser --disabled-password --gecos '' myuser

CMD ["/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
