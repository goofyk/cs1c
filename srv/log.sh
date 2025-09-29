#!/bin/bash 
log() {
    local LEVEL="$1"
    local MESSAGE="$2"
    local LOG_TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S")
    echo "$LOG_TIMESTAMP UTC [${LEVEL}] ${MESSAGE}"
}
