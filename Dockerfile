#
# MQTT/RabbitMQ
#
# based on:
# RabbitMQ Dockerfile
#
# https://github.com/dockerfile/rabbitmq
#

# Pull base image.
FROM dockerfile/ubuntu

# Install RabbitMQ.
RUN wget -qO - http://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - 
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list 

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y rabbitmq-server apg
RUN rm -rf /var/lib/apt/lists/*

ADD rabbitmq.config /etc/rabbitmq/
Run chmod u+rw /etc/rabbitmq/rabbitmq.config

ADD erlang.cookie /var/lib/rabbitmq/.erlang.cookie
RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie

# Add files.
RUN mkdir /opt/rabbit
ADD startrabbit.sh /opt/rabbit/
RUN chmod a+x /opt/rabbit/startrabbit.sh

# initial config
RUN rabbitmq-plugins enable rabbitmq_management rabbitmq_mqtt 

# Expose ports.
EXPOSE 5672
EXPOSE 15672
EXPOSE 1883

CMD /opt/rabbit/startrabbit.sh


