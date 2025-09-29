#!/bin/bash 
set -e 

/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring hazelcast --instance hc_instance service restart 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring elasticsearch --instance elastic_instance service restart 
/opt/1C/1CE/components/1c-enterprise-ring-${RING_VERSION}-x86_64/ring cs --instance cs_instance service restart 

echo "ALL START" 
sh