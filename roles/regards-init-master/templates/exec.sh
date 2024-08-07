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
  COUNTER=0
  for node in $nodes; do
    printf >&2 "[\033[32m$COUNTER\033[m]\t$node\n"
    COUNTER=$((COUNTER+1))
  done;
  read -p 'Which server do you want to connect to? ' nodeId

  # Retrieve the corresponding node
  COUNTER=0
  for node in $nodes; do
    if [ "${COUNTER}" = "${nodeId}" ]
    then
      typeset nodeToConnectTo=${node}
    fi
    COUNTER=$((COUNTER+1))
  done;
else
  typeset nodeToConnectTo=${nodes}
fi

typeset containerName=$(docker service ps --no-trunc --format '{{ '{{' }}.Name{{ '}}' }}.{{ '{{' }}.ID{{ '}}' }}' --filter desired-state=Running --filter node=${nodeToConnectTo} ${stack_name}_${1})

# Remove the first attribute (microservice name) now we've read it
shift;

if [ "${host}" = "${nodeToConnectTo}" ]
then
  typeset command=$(echo "$@")
  exec bash -c "docker exec ${DOCKER_ARGS} ${containerName} ${command}"
else
  exec ssh -t "${nodeToConnectTo}" "docker exec ${DOCKER_ARGS} ${containerName} "$@""
fi
