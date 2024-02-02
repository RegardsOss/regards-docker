
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
# When folder are created, create them with 0770
umask 002

############# COTS FOLDER ##############
{% if role_regards_init_nfs_workspaces_volume_elasticsearch_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_elasticsearch_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_data.get('device_postfix', 'elasticsearch/data') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_data.get('device_postfix', 'elasticsearch/data') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_elasticsearch_backup.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_elasticsearch_backup.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_backup.get('device_postfix', 'elasticsearch/backup') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_backup.get('device_postfix', 'elasticsearch/backup') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_elasticsearch_logs_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_elasticsearch_logs_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_logs_data.get('device_postfix', 'elasticsearch/data-logs') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_logs_data.get('device_postfix', 'elasticsearch/data-logs') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_elasticsearch_logs_backup.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_elasticsearch_logs_backup.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_logs_backup.get('device_postfix', 'elasticsearch/backup-logs') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_elasticsearch_logs_backup.get('device_postfix', 'elasticsearch/backup-logs') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_postgres_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_postgres_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_postgres_data.get('device_postfix', 'postgresql/') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_postgres_data.get('device_postfix', 'postgresql/') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_rabbitmq_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_rabbitmq_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_rabbitmq_data.get('device_postfix', 'rabbitmq') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_rabbitmq_data.get('device_postfix', 'rabbitmq') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_minio_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_minio_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_minio_data.get('device_postfix', 'minio') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_minio_data.get('device_postfix', 'minio') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_loki_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_loki_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_loki_data.get('device_postfix', 'loki/') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_loki_data.get('device_postfix', 'loki/') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_prometheus_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_prometheus_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_prometheus_data.get('device_postfix', 'prometheus/') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_prometheus_data.get('device_postfix', 'prometheus/') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_grafana_data.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_grafana_data.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_grafana_data.get('device_postfix', 'grafana/') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_grafana_data.get('device_postfix', 'grafana/') }}
{% endif %}

############# REGARDS FOLDER ##############
{% if role_regards_init_nfs_workspaces_volume_processing.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_processing.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_processing.get('device_postfix', 'regards/processing') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_processing.get('device_postfix', 'regards/processing') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_dam.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_dam.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_dam.get('device_postfix', 'regards/storage/dam') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_dam.get('device_postfix', 'regards/storage/dam') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_workspace.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_workspace.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_workspace.get('device_postfix', 'regards/workspace') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_workspace.get('device_postfix', 'regards/workspace') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_storage_online.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_storage_online.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_storage_online.get('device_postfix', 'regards/storage/onlines') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_storage_online.get('device_postfix', 'regards/storage/onlines') }}
{% endif %}

{% if role_regards_init_nfs_workspaces_volume_storage_cache.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_storage_cache.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_storage_cache.get('device_postfix', 'regards/storage/cache') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_storage_cache.get('device_postfix', 'regards/storage/cache') }}
{% endif %}


{% if role_regards_init_nfs_workspaces_volume_dam_attachment_input.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_dam_attachment_input.nfs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_dam_attachment_input.get('device_postfix', 'regards/storage/dataset-attachments-input') }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_dam_attachment_input.get('device_postfix', 'regards/storage/dataset-attachments-input') }}
{% endif %}

############# MICROSERVICE LOGS FOLDER ##############
{% if role_regards_init_nfs_workspaces_volume_logs.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_logs.nfs %}
{% for mservice in role_regards_init_nfs_workspaces_volume_mservices_logs %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_logs.get('device_postfix', 'regards/logs/') }}/{{ mservice }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_logs.get('device_postfix', 'regards/logs/') }}/{{ mservice }}
{% endfor %}
{% endif %}

############# MICROSERVICE PLUGINS FOLDER ##############
{% if role_regards_init_nfs_workspaces_volume_plugins.nfs is defined and nfs_server.name == role_regards_init_nfs_workspaces_volume_plugins.nfs %}
{% for mservice in role_regards_init_nfs_workspaces_microservice_having_plugin %}
mkdir -p /shared/{{ role_regards_init_nfs_workspaces_volume_logs.get('device_postfix', 'regards/plugins/') }}/{{ mservice }}
chmod 0770 /shared/{{ role_regards_init_nfs_workspaces_volume_logs.get('device_postfix', 'regards/plugins/') }}/{{ mservice }}
{% endfor %}
{% endif %}

############# REGARDS FOLDER ##############
{% for data_input in role_regards_init_nfs_workspaces_volume_data_inputs %}
{% if data_input.nfs is defined and nfs_server.name == data_input.nfs and data_input.device_postfix is defined %}
mkdir -p /shared/{{ data_input.device_postfix }}
chmod 0770 /shared/{{ data_input.device_postfix }}
{% endif %}
{% endfor %}


{% for top_level_volume in role_regards_init_nfs_workspaces_top_level_volumes %}
{% if top_level_volume.nfs is defined and nfs_server.name == top_level_volume.nfs and top_level_volume.device_postfix is defined %}
mkdir -p /shared/{{ top_level_volume.device_postfix }}
chmod 0770 /shared/{{ top_level_volume.device_postfix }}
{% endif %}
{% endfor %}


result_ok=true

exit 0
