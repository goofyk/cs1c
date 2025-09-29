#!/bin/bash 
set -e 

useradd cs_user 
mkdir -p /var/cs/cs_instance 
chown cs_user:cs_user /var/cs/cs_instance 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs instance create --dir /var/cs/cs_instance --owner cs_user 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance service create --username cs_user --java-home $JAVA_HOME --stopped 

useradd hc_user 
mkdir -p /var/cs/hc_instance 
chown hc_user:hc_user /var/cs/hc_instance 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring hazelcast instance create --dir /var/cs/hc_instance --owner hc_user 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring hazelcast --instance hc_instance service create --username hc_user --java-home $JAVA_HOME --stopped 

useradd elastic_user 
mkdir -p /var/cs/elastic_instance 
chown elastic_user:elastic_user /var/cs/elastic_instance 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring elasticsearch instance create --dir /var/cs/elastic_instance --owner elastic_user 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring elasticsearch --instance elastic_instance service create --username elastic_user --java-home $JAVA_HOME --stopped 

/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance jdbc set-params --url jdbc:postgresql://db:5432/cs_db?currentSchema=public 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance jdbc set-params --username postgres 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance jdbc set-params --password postgres 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance jdbc-privileged set-params --url jdbc:postgresql://db:5432/cs_db?currentSchema=public 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance jdbc-privileged set-params --username postgres 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance jdbc-privileged set-params --password postgres 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance websocket set-params --hostname cs 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance websocket set-params --port 