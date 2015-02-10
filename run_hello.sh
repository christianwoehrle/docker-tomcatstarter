#!/bin/bash
CUR_DIR=$(dirname $0)
cd $CUR_DIR
CLUSTER_NAME="hello"
WAR_DIR=$"/home/dude/docker/docker-tomcat-example/hello"
WEBSERVER="dwptdis3"

./run.sh $CLUSTER_NAME $WAR_DIR $WEBSERVER             

