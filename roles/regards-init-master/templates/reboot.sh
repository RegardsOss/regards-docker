#!/bin/bash -e
if [ $# -lt 1 ]
then
  echo "this command needs add least the service name you want to reboot."
  echo "I don't think it fetches the image"
  echo "Syntax: ./reboot.sh <microservice>"
  echo "Syntax: ./reboot.sh rs-front"
  exit 1
fi

# Check if the service is global
IS_GLOBAL_SERVICE=$(docker service inspect {{ role_regards_init_master_stack_name }}_${1} --format '{{ '{{' }}.Spec.Mode.Global{{ '}}' }}')
if [ "$IS_GLOBAL_SERVICE" == "<nil>" ]; then
  # Service is not global, so we can scale down then up
  # Save the previous number of replica 
  typeset -i NB_REPLICAS
  NB_REPLICAS=$(docker service inspect {{ role_regards_init_master_stack_name }}_${1} --format '{{ '{{' }}.Spec.Mode.Replicated.Replicas{{ '}}' }}')

  docker service scale {{ role_regards_init_master_stack_name }}_${1}=0
  docker service scale {{ role_regards_init_master_stack_name }}_${1}=${NB_REPLICAS}
else
  docker service rm {{ role_regards_init_master_stack_name }}_${1}
  printf >&2 "[\033[32mINFO\033[m]\tGlobal service ${1} has been removed, now readd it using ./deploy.sh\n"
  ./deploy.sh
fi
