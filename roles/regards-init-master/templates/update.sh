#!/bin/bash -e
if [ $# -lt 2 ]
then
  echo "this command needs the name of the container and the tag you want to use"
  echo "Syntax: ./update.sh <microservice> <tag>"
  echo "Syntax: ./update.sh rs-admin fast-develop"
  exit 1
fi

echo "Pull the image {{ role_regards_init_master_registry }}/${1}:${2}"
# Pull latest image on master
docker pull {{ role_regards_init_master_registry }}/${1}:${2}
# Get the ID of that image
declare -r image=`docker image inspect --format '{{ '{{' }} index  .RepoDigests 0 {{ '}}' }}' {{ role_regards_init_master_registry }}/${1}:${2}`
# Update the server and the image used
docker service update --image ${image} --with-registry-auth {{ role_regards_init_master_stack_name }}_${1}
echo "Update succeeded !"
