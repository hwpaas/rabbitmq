##restart docker 
rabbit3 just works
For rabbit2, start container and add rabbit3 ip to /etc/hosts
For rabbit1, start container, add rabbit2 & rabbbit3 ip to /etc/hosts, run rabbitmq-server -detached
