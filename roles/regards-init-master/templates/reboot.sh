#!/bin/bash -e
if [ $# -lt 1 ]
then
  echo "this command needs add least the service name you want to reboot."
  echo "I don't think it fetches the image"
  echo "Syntax: ./reboot.sh <microservice>"
  echo "Syntax: ./reboot.sh rs-front"
  exit 1
fi

typeset -i NB_REPLICAS
NB_REPLICAS=$(docker service inspect {{ role_regards_init_master_stack_name }}_${1} --format '{{ '{{' }}.Spec.Mode.Replicated.Replicas{{ '}}' }}')

docker service scale {{ role_regards_init_master_stack_name }}_${1}=0
docker service scale {{ role_regards_init_master_stack_name }}_${1}=${NB_REPLICAS}
