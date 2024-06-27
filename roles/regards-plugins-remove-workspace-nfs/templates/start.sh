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
cd /plugins
# remove all plugins on every microservices folders
while read fname; do
  echo "Remove all plugins on $fname"
  rm -f "$fname"/*.jar
done <<< "$(find . -not -path . -not -path '*/.*' -type d)"
# ignore current folder "." and folders starting with a dot ".snapshot"
exit 0
