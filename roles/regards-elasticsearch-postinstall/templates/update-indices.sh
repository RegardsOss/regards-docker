#!/bin/bash -e

# Update indices settings
curl --no-progress-meter -X PUT "rs-elasticsearch:9200/_settings" -H 'Content-Type: application/json' -d'
{
    "index" : {
        "number_of_replicas" : {{ role_regards_elasticsearch_sidecar_number_of_replica }}
    }
}
'
