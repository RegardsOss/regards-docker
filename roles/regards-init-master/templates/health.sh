#!/bin/bash -e
# Check health status for specified project using Spring Boot Actuator


# end ##################################################################
function end
{
  if [ $result_ok = "false" ] 
  then
    printf >&2 "[\033[31mN/A\033[m]\tREGARDS not available\n"
    curl -I $url --noproxy '*' --insecure
  fi
}

# abort on nonzero exitstatus
set -o errexit
# don't hide errors within pipes
set -o pipefail

typeset result_ok=false

trap end EXIT

# main ##################################################################

# Param 1 : url to check
function healthCheck
{   
    resultCurl=$(curl -s -I $1 --noproxy '*' --insecure)
    echo $resultCurl | grep HTTP | cut -d' ' -f2
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


if [ $# -gt 1 ]
then
  echo "Syntax: ./health.sh [<tenant>]"
  echo "Test for all tenants by default"
  exit 1
fi

# Fallback to "all", which test all tenants
declare tenant=${1:all}

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
MSERVICE_TO_CONTAINER["worker_manager"]="rs-worker-manager"
MSERVICE_TO_CONTAINER["lta_manager"]="rs-lta-manager"
MSERVICE_TO_CONTAINER["delivery"]="rs-delivery"
MSERVICE_TO_CONTAINER["file_catalog"]="rs-file-catalog"
MSERVICE_TO_CONTAINER["file_access"]="rs-file-access"
MSERVICE_TO_CONTAINER["file_packager"]="rs-file-packager"

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


result_ok=true

exit 0
