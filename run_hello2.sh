#!/bin/bash

CLUSTER_NAME="hello"
WAR_DIR=$"/home/dude/docker/docker-tomcat-example/hello2"
WEBSERVER="dwptdis3"

./run.sh $CLUSTER_NAME $WAR_DIR $WEBSERVER             

