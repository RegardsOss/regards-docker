#!/bin/bash

# end ##################################################################
function end
{
  if [ $result_ok = "false" ] 
  then
    echo "Some error occured:"
    echo $resultCurl
  fi
}

# abort on nonzero exitstatus
set -o errexit
# don't hide errors within pipes
set -o pipefail

typeset result_ok=false

trap end EXIT

# main ##################################################################

# Update indices settings
resultCurl=$(curl -s -X PUT "rs-elasticsearch:9200/_settings" -H 'Content-Type: application/json' -d'
{
    "index" : {
        "number_of_replicas" : {{ role_regards_elasticsearch_postinstall_number_of_replica }}
    }
}
')
echo $resultCurl | jq -e '.acknowledged == true'  > /dev/null

result_ok=true

exit 0
