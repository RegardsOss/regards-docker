
#!/bin/bash

# end ##################################################################
function end
{
  if [ $result_ok = "false" ] 
  then
    echo "Failed to create folder"
  fi
}

# abort on nonzero exitstatus
set -o errexit
# don't hide errors within pipes
set -o pipefail

typeset result_ok=false

trap end EXIT

# main ##################################################################


############# COTS FOLDER ##############
{% if role_regards_init_nfs_workspaces_volume_elasticsearch_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_elasticsearch_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_data.get('device_postfix', 'elasticsearch/data') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_elasticsearch_backup.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_elasticsearch_backup.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_backup.get('device_postfix', 'elasticsearch/backup') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_elasticsearch_logs_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_elasticsearch_logs_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_logs_data.get('device_postfix', 'elasticsearch/data-logs') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_elasticsearch_logs_backup.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_elasticsearch_logs_backup.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_logs_backup.get('device_postfix', 'elasticsearch/backup-logs') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_postgres_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_postgres_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_postgres_data.get('device_postfix', 'postgresql/') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_rabbitmq_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_rabbitmq_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_rabbitmq_data.get('device_postfix', 'rabbitmq') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_s3_minio_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_s3_minio_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_s3_minio_data.get('device_postfix', 's3-minio/') }}
{% endif %}


############# REGARDS FOLDER ##############
{% if role_regards_init_nfs_workspaces_volume_processing.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_processing.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_processing.get('device_postfix', 'regards/processing') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_dam.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_dam.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_dam.get('device_postfix', 'regards/storage/dam') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_workspace.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_workspace.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_workspace.get('device_postfix', 'regards/workspace') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_storage_online.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_storage_online.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_storage_online.get('device_postfix', 'regards/storage/onlines') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_storage_cache.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_storage_cache.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_storage_cache.get('device_postfix', 'regards/storage/cache') }}
{% endif %}


############# MICROSERVICE LOGS FOLDER ##############
{% if role_regards_init_nfs_workspaces_volume_logs.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_logs.nfs %}
{% for mservice in role_regards_init_nfs_workspaces_volume_mservices_logs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_logs.get('device_postfix', 'regards/logs/') }}/{{ mservice }}
{% endfor %}
{% endif %}

############# MICROSERVICE PLUGINS FOLDER ##############
{% if role_regards_init_nfs_workspaces_volume_plugins.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_plugins.nfs %}
{% for mservice in role_regards_init_nfs_workspaces_microservice_having_plugin %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_logs.get('device_postfix', 'regards/plugins/') }}/{{ mservice }}
{% endfor %}
{% endif %}

############# REGARDS FOLDER ##############
{% for data_input in role_regards_init_nfs_workspaces_volume_data_inputs %}
{% if data_input.nfs is defined and nfs_server.name == data_input.nfs %}
mkdir -p /shared/{{ data_input.device_postfix }}
{% endif %}
{% endfor %}


{% for top_level_volume in role_regards_init_nfs_workspaces_top_level_volumes %}
{% if top_level_volume.nfs is defined and nfs_server.name == top_level_volume.nfs %}
mkdir -p /shared/{{ top_level_volume.device_postfix }}
{% endif %}
{% endfor %}


result_ok=true

exit 0
