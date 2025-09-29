#!/bin/bash 
set -e 

useradd cs_user 
mkdir -p /var/cs/cs_instance 
chown cs_user:cs_user /var/cs/cs_instance 
chown cs_user: /usr/local/bin
chmod u+w /usr/local/bin
ring -l error cs instance create --dir /var/cs/cs_instance --owner cs_user 
ring -l error cs --instance cs_instance service create --username cs_user --java-home $JAVA_HOME --stopped 

useradd hc_user 
mkdir -p /var/cs/hc_instance 
chown hc_user:hc_user /var/cs/hc_instance 
chown hc_user: /usr/local/bin
chmod u+w /usr/local/bin
ring -l error hazelcast instance create --dir /var/cs/hc_instance --owner hc_user 
ring -l error hazelcast --instance hc_instance service create --username hc_user --java-home $JAVA_HOME --stopped 

useradd elastic_user 
mkdir -p /var/cs/elastic_instance 
chown elastic_user:elastic_user /var/cs/elastic_instance 
chown elastic_user: /usr/local/bin
chmod u+w /usr/local/bin

ring -l error elasticsearch instance create --dir /var/cs/elastic_instance --owner elastic_user 
ring -l error elasticsearch --instance elastic_instance service create --username elastic_user --java-home $JAVA_HOME --stopped 

ring -l error cs --instance cs_instance jdbc pools --name common set-params --url jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB?currentSchema=public
ring -l error cs --instance cs_instance jdbc pools --name common set-params --username $POSTGRES_USER
ring -l error cs --instance cs_instance jdbc pools --name common set-params --password $POSTGRES_PASSWORD
ring -l error cs --instance cs_instance jdbc pools --name privileged set-params --url jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB?currentSchema=public
ring -l error cs --instance cs_instance jdbc pools --name privileged  set-params --username $POSTGRES_USER
ring -l error cs --instance cs_instance jdbc pools --name privileged set-params --password $POSTGRES_PASSWORD
ring -l error cs --instance cs_instance websocket set-params --hostname $CS_HOST
ring -l error cs --instance cs_instance websocket set-params --port $CS_PORT