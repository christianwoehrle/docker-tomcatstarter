#!/bin/bash
CUR_DIR=$(dirname $0)
cd $CUR_DIR


echo "usage: stopDude <tomcat-id>"
TOMCAT_ID=${1}
if [ $# != 1 ]
then
exit 1
fi


echo "Startparameter"
echo "=============="
echo "TOMCAT_ID= $TOMCAT_ID"
echo "=============="

docker rm -f $TOMCAT_ID



curl localhost:8500/v1/agent/service/deregister/$TOMCAT_ID

echo  "Event TomcatServiceUp feuern" 
#Event ueber gestarteten Service an Consul geben"
consul event -name "TomcatServiceUp"
#http://localhost:8500/ui/#/cw/services


