#!/bin/bash -e

# Param 1 : file to send
function sendConfigFile
{   
  resultImport=$(curl --no-progress-meter -X POST "rs-logs-kibana:5601/api/saved_objects/_import?overwrite=true" -H "kbn-xsrf: true" -F file=@$1)
  hasError=$(echo $resultImport | jq --exit-status '.statusCode == 200')
  if [ $hasError == "false" ]; then
    echo $resultImport
    exit 1
  fi
}

# Import Log HMI Settings 
sendConfigFile kibana-settings.json

# Import Log Search view
sendConfigFile logs_kibana_visu.json
