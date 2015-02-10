#!/bin/bash
CUR_DIR=$(dirname $0)
cd $CUR_DIR
CLUSTER_NAME="Dude"
WAR_DIR=$"/home/dude/docker/docker-tomcat-example/Dude"
WEBSERVER="dwptdis3"
CONTEXT_ROOT="Dude"

./run.sh $CLUSTER_NAME $WAR_DIR $WEBSERVER $CONTEXT_ROOT

