#
# MQTT/RabbitMQ
#
# based on:
# RabbitMQ Dockerfile
#
# https://github.com/dockerfile/rabbitmq
#

# Pull base image.
#FROM dockerfile/ubuntu
FROM phusion/baseimage:0.9.15

# Set correct environment variables.
ENV HOME /root

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get install -y byobu curl git htop man unzip vim wget && \
  rm -rf /var/lib/apt/lists/*

# Install RabbitMQ.
RUN wget -qO - http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - 
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list 

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server apg
#RUN rm -rf /var/lib/apt/lists/*

ADD rabbitmq.config /etc/rabbitmq/
Run chmod u+rw /etc/rabbitmq/rabbitmq.config

ADD erlang.cookie /var/lib/rabbitmq/.erlang.cookie
RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie

# Add files.
#RUN mkdir /opt/rabbit
#ADD startrabbit.sh /opt/rabbit/
#RUN chmod a+x /opt/rabbit/startrabbit.sh
RUN mkdir -p /etc/my_init.d
ADD startrabbit.sh /etc/my_init.d/startrabbit.sh

# initial config
RUN rabbitmq-plugins enable rabbitmq_management rabbitmq_mqtt 

# Expose ports.
EXPOSE 5672
EXPOSE 15672
EXPOSE 1883

#CMD /opt/rabbit/startrabbit.sh
# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
