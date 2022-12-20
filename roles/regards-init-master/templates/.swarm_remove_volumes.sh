#!/bin/bash -e

# Remove all volumes associated to the stack, as they are not removed once stack has been removed
# @source https://github.com/moby/moby/issues/29158#issuecomment-663793782
STACK_NAME={{ role_regards_init_master_stack_name }};
for volume in $(docker volume ls --filter label=com.docker.stack.namespace=$STACK_NAME -q); do
  while true; do
    typeset list_volume_dangling=$(docker volume ls -q -f dangling=true)
    if printf '%s\n' ${list_volume_dangling[@]} | grep -q --line-regexp ${volume}; then
      printf >&2 "  [\033[32mVOLUME\033[m]\tRemoving volume "
      docker volume rm ${volume}
      break
    else
      printf >&2 "  [\033[34mVOLUME\033[m]\tWaiting dangling volume ${volume}\n"
      sleep 1
    fi
  done
done
