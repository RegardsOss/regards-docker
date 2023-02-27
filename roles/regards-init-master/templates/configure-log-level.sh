#!/bin/bash -e
# Hot logs level consultation and configuration using actuator

function hr
{
    echo "------------------------------------------------------------------------------------------------------------------"
}

# Param 1 : url
function consult_level
{   
    result=$(curl -s "$1" --noproxy '*' --insecure)
    # Is jq available?
    if [ -x "$(command -v jq)" ]; then
        echo ${result} | jq
    else
        echo ${result}
    fi
}

function update_level
{
    echo "old configured levels > "
    consult_level "$1"
    configuredLevel="{\"configuredLevel\": \"$2\"}"
    if curl -i -X POST -H 'Content-Type: application/json' --noproxy '*' --insecure -d "${configuredLevel}" "$1" > /dev/null 2>&1; then
        hr
        echo "new configured levels > "
        consult_level "$1"
    else
        printf >&2 "[\033[31mLog level update failed\033[m]\t\n" 
    fi
}

function usage
{
    echo "Syntax: ./configure_level.sh -m <microservice> [-p package] [-l level]"
    exit 1
}

# PARAMETERS
declare GATEWAY_URL=$(echo "{{ role_regards_init_public_url }}" | tr -d '\\')
declare ACTUATOR="/actuator/loggers/"
declare TENANT="instance" # Valid for all tenants

# Tests
declare microservice=""
declare package=""
declare level=""

while getopts m:p:l: flag
do
    case "${flag}" in
        m) microservice=${OPTARG};;
        p) package=${OPTARG};;
        l) level=${OPTARG};;
    esac
done

# Check input parameters
if [ -z "${microservice}" ]; then
    printf >&2 "[\033[31mMissing microservice name\033[m]\t\n" 
    usage
fi

# MAIN
url="${GATEWAY_URL}/api/v1/${microservice}${ACTUATOR}${package}?scope=${TENANT}"
hr
if ! [ -z "${level}" ]; then
    # Update mode
    update_level "${url}" "${level}"
else
    # Consult only mode
    consult_level "${url}"
fi
hr
echo "Log levels for:"
printf >&2 "microservice :\t[\033[32m${microservice}\033[m]\n"
if ! [ -z "${package}" ]; then
    printf >&2 "package      :\t[\033[32m${package}\033[m]\n"
fi
if ! [ -z "${level}" ]; then
    printf >&2 "level        :\t[\033[32m${level}\033[m]\n"
fi
hr
