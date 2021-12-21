#!/bin/bash -e

# Display last containers that shutdowned
# As Docker does not allow it, we do it manually
# 1- List all shutdown containers
# 2- remove history
# 3- remove the stack name
# 4- add a column that translate "Shutdown 2 days ago" into ISO date. 
#    Also supports "Shutdown about a day ago", "Less than a second ago" or "Shutdown an hour ago" that are not supported by date program. 
# 5- sort on that date
# 6- remove the ISO date and add colors
# 7- make the output readable
ALL_DEAD_CONTAINERS=$(docker stack ps --no-trunc -f  "desired-state=shutdown" --format '{{ '{{' }} .CurrentState {{ '}}' }}\t{{ '{{' }} .Name {{ '}}' }}\t{{ '{{' }}.Node{{ '}}' }}\t{{ '{{' }}.Error{{ '}}' }}' {{ role_regards_init_master_stack_name }} \
| grep -v '\\_' \
| sed --unbuffered -e "s/{{ role_regards_init_master_stack_name }}_//" \
| awk -F'\t' '{system("date --rfc-3339=seconds -u -d \"$(printf \"" $1 "\" | cut -d \" \" -f2- | sed \"s/about//g\" | sed \"s/less than//g\" | sed \"s/an /1 /g\") \" | tr -d \"\n\"") ; printf "\t%s\t%s\t%s\t%s\t%s\n", $1, $2, $3, $4, $5;}' \
| sort -r \
| awk -F'\t' '{ printf "\033[33m%s\033[39m\t%s\t%s\t\033[31m%s \033[39m\n", $2, $3, $4, $5, $6;}' \
| column -o " " -t -s $'\t')


# Test there is dead containers (first line is header)
typeset -i NB_DEAD_CONTAINERS
NB_DEAD_CONTAINERS=$(printf "$ALL_DEAD_CONTAINERS" |wc -l)
if [ $NB_DEAD_CONTAINERS -gt 0 ]; then
  printf >&2 "[\033[33mHISTORY\033[m]\t LIST CONTAINERS THAT SHUTDOWNED RECENTLY\n"
  echo "$ALL_DEAD_CONTAINERS" | head -n 15
  if [ $NB_DEAD_CONTAINERS -gt 15 ]; then
    IGNORED_DEAD_CONTAINERS=$((NB_DEAD_CONTAINERS-15))
    echo "...$IGNORED_DEAD_CONTAINERS more ignored"
  fi
fi

# Running containers count

# Display how many containers are missing
typeset -i MAX_NB_CONTAINERS
typeset -i NB_CONTAINERS
MAX_NB_CONTAINERS={{ 1 + role_regards_init_master_mservices | length + role_regards_init_master_cots | length + role_regards_init_workers | length + role_regards_init_has_many_fluentd|bool | ternary(groups['regards_nodes'] | length - 1, 0)}}
NB_CONTAINERS=$(docker stack ps -f "desired-state=running" {{ role_regards_init_master_stack_name }} |wc -l)
if [ $MAX_NB_CONTAINERS -eq $NB_CONTAINERS ]; then
  printf >&2 "[\033[32mRUNNING\033[m]\t$NB_CONTAINERS/$MAX_NB_CONTAINERS\n"
else
  printf >&2 "[\033[31mRUNNING\033[m]\t\033[31m$NB_CONTAINERS\033[m/\033[32m$MAX_NB_CONTAINERS\033[m - \033[33m Some expected containers are not running !\033[m\n"
fi


# Running containers list
docker stack ps -f "desired-state=running" --format '{{ '{{' }} .CurrentState {{ '}}' }}\t{{ '{{' }} .Name {{ '}}' }}\t{{ '{{' }}.Node{{ '}}' }}\t{{ '{{' }}.Image{{ '}}' }}' {{ role_regards_init_master_stack_name }} \
  | sed --unbuffered -e "s/{{ role_regards_init_master_stack_name }}_//" \
  | awk -F'\t' '{system("date --rfc-3339=seconds -u -d \"$(printf \"" $1 "\" | cut -d \" \" -f2- | sed \"s/about//g\" | sed \"s/less than//g\" | sed \"s/an /1 /g\") \" | tr -d \"\n\"") ; printf "\t%s\t%s\t%s\t%s\t%s\n", $1, $2, $3, $4, $5;}' \
  | sort -r \
  | awk -F'\t' '{ printf "\033[32m%s\033[39m\t%s\t%s\t%s\n", $2, $3, $4, $5, $6;}' \
  | column -o " " -t -s $'\t'

# Display microservices that are not up
MISSING_SERVICES=$(docker stack services --format '{{ '{{' }} .Name {{ '}}' }}\t{{ '{{' }}split .Replicas "/"{{ '}}' }}' {{ role_regards_init_master_stack_name }} \
  | sed 's/[][]//g' \
  | sed --unbuffered -e "s/{{ role_regards_init_master_stack_name }}_//" \
  | awk '$2!=$3{printf "%s %s active / %s expected\n", $1,$2, $3;}')

typeset -i nbMissingServices
nbMissingServices=$(printf "$MISSING_SERVICES" |wc -l)
if [ $nbMissingServices -gt 0 ]; then
  printf >&2 "[\033[31mERROR\033[m]\t MISSING SERVICES\n"
  printf >&2 "NAME  /  REPLICATION STATUS\n"
  echo "$MISSING_SERVICES"
fi
