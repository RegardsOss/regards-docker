#!/bin/bash -e

printf "[\033[33mBe carreful!\033[m]\t5 This command only shows stats of the current Docker node"

# Display stats for the current 
docker stats --all \
  --format "table {{ '{{' }}.Name{{ '}}' }}\t{{ '{{' }}.CPUPerc{{ '}}' }}\t{{ '{{' }} .MemPerc {{ '}}' }}\t{{ '{{' }}.MemUsage{{ '}}' }}\t{{ '{{' }}.BlockIO {{ '}}' }}\t{{ '{{' }}.NetIO {{ '}}' }}" \
  $(docker ps --format '{{ '{{' }}.Names{{ '}}' }}' | grep {{ role_regards_init_master_stack_name }} ) \
  | sed --unbuffered -e "s/{{ role_regards_init_master_stack_name }}_//"
