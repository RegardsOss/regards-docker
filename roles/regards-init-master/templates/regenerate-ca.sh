#!/bin/bash -e

# Recreate Swarm CA - useful to fix issues while retrieving logs using logs.sh
# When you failed to retrieve logs from the Swarm master with the following error : 
# error from daemon in stream: Error grabbing logs: rpc error: code = Unknown desc = warning: incomplete log stream. 
# some logs could not be retrieved for the following reasons: node xxx is not available
# @see https://github.com/moby/moby/issues/35011
# just run this script ....

docker swarm ca --rotate
