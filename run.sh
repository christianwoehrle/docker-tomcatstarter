#!/bin/bash
# Script starts a tomcat container, registers it in a local consul instance and fires a consul event

echo "usage: run clustername war-dir webserver contextroot"
echo " - clustername is the name of a cluster of tomcat instances, that all share the same webapplication/configuration and can be load balanced"#
echo " - war dir is the directory containing the war file(s)"
echo " - webserver is the server name, where the configuration sould be updated"
echo " - contextroot is the part of the url, where tomcat is bound into to webserver via JKMount"


curdir=$(dirname $0)
cd "$curdir"

CLUSTER_NAME=${1-"vhost1"}
WAR_DIR=${2-"/hello"}
WEBSERVER=${3-"dwptdis3"}
CONTEXT_ROOT=${4-"/Dude/"}

HOSTNAME=$(hostname)

INTERNAL_PORT=8009
VHOSTNAME="vhost"

source ~/ports.properties
TOMCAT_PORT=$(( TOMCAT_PORT + 1))
echo "TOMCAT_PORT=$TOMCAT_PORT" > ~/ports.properties

echo "Startparameter"
echo "=============="
echo "CLUSTER_NAME:                       $CLUSTER_NAME"
echo "WAR_DIR:                            $WAR_DIR"
echo "TOMCAT_PORT (extern sichtbar):      $TOMCAT_PORT "
echo "=============="

JVM_ROUTE=tomcat_${HOSTNAME}_${TOMCAT_PORT}

CONTAINER_ID=$(docker run -d -p $TOMCAT_PORT:8080 --name $JVM_ROUTE --env TOMCAT_JVM_ROUTE=$JVM_ROUTE -v $WAR_DIR:/webapps rossbachp/tomcat8)
echo "Container gestartet, CONTAINER_ID:  $CONTAINER_ID"

IP_ADDRESS=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' $CONTAINER_ID )
echo "Container IP_ADDRESS:               $IP_ADDRESS " 

echo "Container in Consul als Service anmelden"

curl -X PUT -d '{"ID": "'$JVM_ROUTE'","Name":"'$CLUSTER_NAME'", "Tags": [ "tomcatHost_'$HOSTNAME'", "contextRoot_'$CONTEXT_ROOT'",  "webserver_'$WEBSERVER'", "webserverVhostName_'$VHOSTNAME'", "internalIP_'$IP_ADDRESS'", "internalPort_'$INTERNAL_PORT'"],"Port":'$TOMCAT_PORT' }' localhost:8500/v1/agent/service/register 

echo "Event TomcatServiceUp feuern"
consul event -name "TomcatServiceUp"

#http://localhost:8500/ui/#/cw/services

echo "Service abfragen (curl localhost:8500/v1/agent/services)"
echo "Serviceabfrage ist reine Prüfung, ob Service richtig eingestragen wurde)"

SERVICE=$(curl localhost:8500/v1/agent/services)
#SERVICE=$(echo \'$SERVICE\')

echo "Serviceabfrage ergab: $SERVICE"
java -jar HttpTomcatMediator-0.0.1-SNAPSHOT.jar   "$SERVICE"

#echo "DEREGISTER (curl localhost:8500/v1/agent/service/deregister/$CONTAINER_ID)"
#curl localhost:8500/v1/agent/service/deregister/$CONTAINER_ID
#echo "Container wieder loeschen"
#docker kill $CONTAINER_ID
#docker rm $CONTAINER_ID


