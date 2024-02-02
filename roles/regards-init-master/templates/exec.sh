#!/bin/bash -e
if [ $# -lt 2 ]
then
  echo "this command requires the service name that you want to connect to and the command itself."
  echo "Syntax: ./exec.sh <microservice> <your command>"
  echo "Syntax: ./exec.sh rs-admin bash"
  exit 1
fi
typeset DOCKER_ARGS="-ti"
typeset host=$(hostname -f)
typeset stack_name={{ role_regards_init_master_stack_name }}
typeset nodes=$(docker service ps --format '{{ '{{' }}.Node{{ '}}' }}' --filter desired-state=Running ${stack_name}_${1})
typeset nbNodes=$(echo "$nodes" | wc -l)

# Check if there is several containers
if [ "$nbNodes" -gt 1 ]; then
  printf "[\033[33mFAILED\033[m]\t Too many nodes detected for that service"
  exit 1
fi

typeset containerId=$(docker service ps --no-trunc --format '{{ '{{' }}.ID{{ '}}' }}' --filter desired-state=Running ${stack_name}_${1})
typeset containerName="${stack_name}_${1}.1.${containerId}"

# Remove the first attribute (microservice name) now we've read it
shift;

if [ "${host}" = "${nodes}" ]
then
  typeset command=$(echo "$@")
  exec bash -c "docker exec ${DOCKER_ARGS} ${containerName} ${command}"
else
  exec ssh -t "${nodes}" "docker exec ${DOCKER_ARGS} ${containerName} "$@""
fi
