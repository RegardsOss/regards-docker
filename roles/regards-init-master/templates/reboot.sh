#!/bin/bash -e
if [ $# -lt 1 ]
then
  echo "this command needs add least the service name you want to reboot."
  echo "I don't think it fetches the image"
  echo "Syntax: ./reboot.sh <microservice>"
  echo "Syntax: ./reboot.sh rs-front"
  exit 1
fi
docker service scale {{ role_regards_init_master_stack_name }}_${1}=0
docker service scale {{ role_regards_init_master_stack_name }}_${1}=1
