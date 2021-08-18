#!/bin/bash -e
echo "Shutdown stack {{ role_regards_init_master_stack_name }} ? (y/n)"
read response
if [ "$response" = "y" ] ; then
  echo "Shutdown in progress for stack {{ role_regards_init_master_stack_name }} ..."
  docker stack rm {{ role_regards_init_master_stack_name }}
  echo "Shutdown ok"
fi
