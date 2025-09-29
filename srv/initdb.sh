#!/bin/bash 
. ./log.sh

set -e 

log INFO "Init DB"

bucket_server_init(){
    RESPONSE=$(curl -Sf -X POST -H "Content-Type: application/json" \
                -d "{ 
                        \"url\" : \"jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB\", 
                        \"username\" : \"$POSTGRES_USER\", 
                        \"password\" : \"$POSTGRES_USER\", 
                        \"enabled\" : true 
                    }" \
                -u admin:admin http://localhost:8087/admin/bucket_server)
    log INFO "Bucket server init: $RESPONSE"
}

storage_server_init(){
    
    echo "$MINIO_HOST:$MINIO_PORT $MINIO_USER $MINIO_PASSWORD $MINIO_BUCKET"

    python3 s3.py $MINIO_HOST:$MINIO_PORT $MINIO_USER $MINIO_PASSWORD $MINIO_BUCKET "eu-west-1"

    RESPONSE=$(curl -Sf -X POST -H "Content-Type: application/json" \
                -d "{ 
                        \"apiType\": \"AMAZON\", 
                        \"storageType\": \"DEFAULT\", 
                        \"baseUrl\": \"http://$MINIO_HOST:$MINIO_PORT\", 
                        \"containerUrl\": \"http://$MINIO_HOST:$MINIO_PORT/\${container_name}\", 
                        \"containerName\": \"$MINIO_BUCKET\", 
                        \"region\": \"eu-west-1\", 
                        \"accessKeyId\": \"$MINIO_USER\", 
                        \"secretKey\": \"$MINIO_PASSWORD\", 
                        \"signatureVersion\": \"V2\", 
                        \"uploadLimit\": 1073741824, 
                        \"downloadLimit\": 1073741824, 
                        \"fileSizeLimit\": 104857600, 
                        \"bytesToKeep\": 104857600, 
                        \"daysToKeep\": 31, 
                        \"pathStyleAccessEnabled\": true 
                    }" \
                -u admin:admin http://localhost:8087/admin/storage_server)
    log INFO "Storage server init: $RESPONSE"
}

bucket_server_init
storage_server_init