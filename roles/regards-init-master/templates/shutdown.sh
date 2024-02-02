#!/bin/bash -e

# Ask user 
declare askBeforeContinuing=1

while getopts y flag
do
    case "${flag}" in
        y) askBeforeContinuing=0;;
    esac
done

if [ "${askBeforeContinuing}" == 1 ] ; then
    echo "Shutdown stack {{ role_regards_init_master_stack_name }} ? (y/n)"
    read response
fi

if [[ "${askBeforeContinuing}" == 0 || "$response" = "y" ]] ; then
  echo "Shutdown in progress for stack {{ role_regards_init_master_stack_name }} ..."
  if docker stack rm {{ role_regards_init_master_stack_name }}; then
    # Encode the script before sending it threw SSH
    SWARM_REMOVE_VOLUMES=$(base64 -w0 {{ role_regards_init_master_cli }}.swarm_remove_volumes.sh)

{%   for hostname in groups['all'] %}
{%     if (groups['swarm_manager_only_nodes'] is defined) and (hostname in groups['swarm_manager_only_nodes']) %}
    # Server {{ hostvars[hostname]['ansible_host'] }} is manager only, so there is no volume on it
{%     else %}
{%       if hostname == groups['master'][0] %}
    printf >&2 "\n\n[\033[32mLOCAL\033[m]\tRemoving volumes on current server...\n"
    {{ role_regards_init_master_cli }}.swarm_remove_volumes.sh
    printf >&2 "[\033[32mLOCAL\033[m]\tVolumes correctly removed on current server.\n"
{%       else %}
    printf >&2 "\n\n[\033[32mSSH\033[m]\tConnecting to {{ hostvars[hostname]['ansible_host'] }} threw SSH...\n"
    ssh {{ hostvars[hostname]['ansible_host'] }} "echo $SWARM_REMOVE_VOLUMES | base64 -d | bash"
    printf >&2 "[\033[32mSSH\033[m]\tVolumes correctly removed on {{ hostvars[hostname]['ansible_host'] }}.\n"
{%       endif %}
{%     endif %}
{%   endfor %}
    echo "Shutdown ok"
  fi
fi
