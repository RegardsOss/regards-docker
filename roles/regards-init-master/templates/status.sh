#!/bin/bash -e
# Dead containers

printf >&2 "[\033[33mHISTORY\033[m]\t5 PREVIOUS CONTAINERS\n"
docker stack ps --no-trunc -f "desired-state=shutdown" {{ role_regards_init_master_stack_name }} | head

# Running containers

# Display how many containers are missing
typeset -i MAX_NB_CONTAINERS={{ 1 + role_regards_init_master_mservices | length + role_regards_init_master_cots | length + role_regards_init_has_many_fluentd|bool | ternary(groups['regards_nodes'] | length - 1, 0)}}
typeset -i NB_CONTAINERS=$(docker stack ps -f "desired-state=running" {{ role_regards_init_master_stack_name }} |wc -l)
printf >&2 "[\033[32mRUNNING\033[m]\t$NB_CONTAINERS/$MAX_NB_CONTAINERS\n"
docker stack ps -f "desired-state=running" {{ role_regards_init_master_stack_name }}

