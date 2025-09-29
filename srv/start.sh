#!/bin/bash 
. ./log.sh

set -e 

ring -l error cs --instance cs_instance service restart 
log "INFO" "CS: $(ring -l error cs --instance cs_instance service status)"

ring -l error hazelcast --instance hc_instance service restart 
log "INFO" "HAZELCAST: $(ring -l error hazelcast --instance hc_instance service status)"

ring -l error elasticsearch --instance elastic_instance service restart 
log "INFO" "ELASTICSEARCH: $(ring -l error elasticsearch --instance elastic_instance service status)"

cs_is_live(){
    RESPONSE=$(curl -s "http://localhost:8087/rs/health")
    STATUS=$(echo "$RESPONSE" | jq -r '.status')
    if [ "$STATUS" = "UP" ]; then return 1; else return 0; fi
}

while cs_is_live = 0; do sleep 5; done

sh ./initdb.sh

sh