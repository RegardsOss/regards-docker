#!/bin/bash -e
if [ $# -lt 1 ]
then
  echo "this command requires the service name that you want to see logs. You can also pass -f to be attached to logs"
  echo "Syntax: ./logs.sh <microservice>"
  echo "Syntax: ./logs.sh rs-admin -f"
  echo "Syntax: ./logs.sh rs-admin -f --tail 200"
  exit 1
fi

mName=$1
secondParam=$2
# Remove the first attribute (./logs.sh) as we dont need it
shift
allCmdParams=$@

# Get the list of alive container
ids=`docker service ps --format '{{ '{{' }}.ID{{ '}}' }}' --filter desired-state=Running {{ role_regards_init_master_stack_name }}_$mName`
nbIds=`echo "$ids" | wc -l`

# Check if there is several containers and we want to be attached to them
if [ ${nbIds} -gt 1 -a $(expr "$secondParam" :  "-f") -gt 0 ]; then
  printf "[\033[33mBe carreful!\033[m]\t5 This command prints logs from dead containers! Remove -f to avoid that"
  docker service logs {{ role_regards_init_master_stack_name }}_$mName $allCmdParams | sed --unbuffered \
        -e "s/^\({{ role_regards_init_master_stack_name }}.\+    | \)//" \
        -e "s/\( \[$mName\] \)/ /" \
        -e "s/\(INFO\)/\o033[32m\1\o033[39m/" \
        -e "s/\(WARN\)/\o033[33m\1\o033[39m/" \
        -e "s/\(DEBUG\)/\o033[34m\1\o033[39m/" \
        -e "s/\(ERROR\)/\o033[31m\1\o033[39m/"
else
  # Otherwise fallback to reliable logs
  for id in ${ids}; do
    docker service logs ${id} $allCmdParams | sed --unbuffered \
        -e "s/^\({{ role_regards_init_master_stack_name }}.\+    | \)//" \
        -e "s/\( \[$mName\] \)/ /" \
        -e "s/\(INFO\)/\o033[32m\1\o033[39m/" \
        -e "s/\(WARN\)/\o033[33m\1\o033[39m/" \
        -e "s/\(DEBUG\)/\o033[34m\1\o033[39m/" \
        -e "s/\(ERROR\)/\o033[31m\1\o033[39m/"
  done
fi
