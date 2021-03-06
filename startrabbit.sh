#!/bin/bash

if [ -z "$CLUSTERED" ]; then
	# if not clustered then start it normally as if it is a single server
	rabbitmq-server -detached
else
	if [ -z "$CLUSTER_WITH" ]; then
		# If clustered, but cluster with is not specified then again start normally, could be the first server in the
		# cluster
		rabbitmq-server -detached
	else
		rabbitmq-server -detached
		rabbitmqctl stop_app
		if [ -z "$RAM_NODE" ]; then
			rabbitmqctl join_cluster rabbit@$CLUSTER_WITH
		else
			rabbitmqctl join_cluster --ram rabbit@$CLUSTER_WITH
		fi
		rabbitmqctl start_app

		# Tail to keep the a foreground process active..
		tail -f /var/log/rabbitmq/rabbit\@$HOSTNAME.log
	fi
fi

