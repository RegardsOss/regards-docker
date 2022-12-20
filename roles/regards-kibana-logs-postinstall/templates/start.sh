#!/bin/bash

# end ##################################################################
function end
{
  if [ $result_ok = "false" ] 
  then
    echo "Failed to import last file:"
    echo $resultImport
  fi
}

# abort on nonzero exitstatus
set -o errexit
# don't hide errors within pipes
set -o pipefail

typeset result_ok=false

trap end EXIT

# main ##################################################################

# Param 1 : file to send
function sendConfigFile
{   
  echo "Starting $1 upload..."
  resultImport=$(curl -s -X POST "rs-logs-kibana:5601/api/saved_objects/_import?overwrite=true" -H "kbn-xsrf: true" -F file=@$1)
  # jq fails if the value at this json path is not the one expected
  echo $resultImport | jq -e '.success == true'  > /dev/null
  echo "$1 successfully imported."
}

# Import Log HMI Settings 
sendConfigFile kibana-settings.ndjson

# Import Log Search view
sendConfigFile logs_kibana_visu.ndjson

result_ok=true

exit 0
