#!/bin/bash -e
# Check health status for specified project using Spring Boot Actuator

# Param 1 : url to check
function healthCheck
{   
    echo $(curl -s -I $1 --noproxy '*' | grep HTTP | cut -d' ' -f2)
}

# Param 1 : HTTP status
# Param 2 : Description label
function display
{
    if [ $1 -eq "200" ] 
    then
        printf >&2 "[\033[32m$1\033[m]\t$2\n"
    else
        printf >&2 "[\033[31m$1\033[m]\t$2\n"
    fi
}


if [ $# -lt 1 ]
then
  echo "Syntax: ./health.sh <tenant>"
  exit 1
fi

declare tenant=${1}

declare -A MSERVICE_TO_CONTAINER;
MSERVICE_TO_CONTAINER["admin_instance"]="rs-admin-instance"
MSERVICE_TO_CONTAINER["admin"]="rs-admin"
MSERVICE_TO_CONTAINER["authentication"]="rs-authentication"
MSERVICE_TO_CONTAINER["dam"]="rs-dam"
MSERVICE_TO_CONTAINER["notifier"]="rs-notifier"
MSERVICE_TO_CONTAINER["fem"]="rs-fem"
MSERVICE_TO_CONTAINER["catalog"]="rs-catalog"
MSERVICE_TO_CONTAINER["access_instance"]="rs-access-instance"
MSERVICE_TO_CONTAINER["access_project"]="rs-access-project"
MSERVICE_TO_CONTAINER["storage"]="rs-storage"
MSERVICE_TO_CONTAINER["order"]="rs-order"
MSERVICE_TO_CONTAINER["ingest"]="rs-ingest"
MSERVICE_TO_CONTAINER["dataprovider"]="rs-dataprovider"
MSERVICE_TO_CONTAINER["processing"]="rs-processing"

# PARAMETERS
declare GATEWAY_URL=$(echo "{{ role_regards_init_public_url }}" | tr -d '\\')

# MAIN

declare ACTUATOR="/actuator/health"

{% for mservice in role_regards_init_master_mservices %}
{% if mservice != 'gateway' and mservice != 'config' and mservice != 'registry' and mservice != 'front' %}
container=${MSERVICE_TO_CONTAINER["{{ mservice }}"]}
url="${GATEWAY_URL}/api/v1/${container}${ACTUATOR}?scope=${tenant}"
status=$(healthCheck ${url})
display "${status}" "{{ mservice }}"

{% endif %}
{% endfor %}