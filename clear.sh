#!/bin/bash 
rm -r storage/
docker volume  prune -a --force
docker system prune -a --force
