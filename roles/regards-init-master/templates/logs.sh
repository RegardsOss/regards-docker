#!/bin/bash -e
if [ $# -lt 1 ]
then
  echo "this command requires the service name that you want to see logs. You can also pass -f to be attached to logs"
  echo "Syntax: ./logs.sh <microservice>"
  echo "Syntax: ./logs.sh rs-admin -f"
  echo "Syntax: ./logs.sh rs-admin -f --tail 200"
  exit 1
fi

# Get the list of alive container
ids=`docker service ps --format '{{ '{{' }}.ID{{ '}}' }}' --filter desired-state=Running {{ role_regards_init_master_stack_name }}_${1}`
nbIds=`echo "$ids" | wc -l`

# Check if there is several containers and we want to be attached to them
if [ ${nbIds} -gt 1 -a $(expr "$2" :  "-f") -gt 0 ]; then
  printf "[\033[33mBe carreful!\033[m]\t5 This command prints logs from dead containers! Remove -f to avoid that"
  # Remove the first attribute (microservice name) now we've read it
  shift
  docker service logs {{ role_regards_init_master_stack_name }}_${0} $@
else
  # Remove the first attribute (microservice name) now we've read it
  shift
  # Otherwise fallback to reliable logs
  for id in ${ids}; do
    docker service logs ${id} $@
  done
fi