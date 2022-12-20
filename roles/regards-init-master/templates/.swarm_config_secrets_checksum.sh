#!/bin/bash -e

function get_checksum
{
  printf $(md5sum $1 | cut -f 1 -d " ")
}

function create_env
{
  export "$1=$(get_checksum $2)"
}

###############################################
################## FRONTEND ###################
###############################################

{% if role_regards_init_master_mservices.front is defined %}
create_env CHECKSUM_RS_FRONT_NGINX_CONF {{ role_regards_init_master_config }}regards/nginx/nginx.conf

{% if role_regards_init_master_mservices.front.show_footer|default(false)|bool %}
create_env CHECKSUM_RS_FRONT_VERSION_FOOTER_HTML {{ role_regards_init_master_config }}regards/nginx/footer/regards-version-footer.html
create_env CHECKSUM_RS_FRONT_FOOTER_CNES_LOGO_PNG {{ role_regards_init_master_config }}regards/nginx/footer/imgs/CNES_Logo_Blanc_Horizontal.png
create_env CHECKSUM_RS_FRONT_FOOTER_REGARDS_PNG {{ role_regards_init_master_config }}regards/nginx/footer/imgs/Regards.png
{% endif %}

{% if role_regards_init_master_mservices.front.ssl is defined %}
create_env CHECKSUM_RS_FRONT_SSL_CRT {{ role_regards_init_master_config }}regards/nginx/ssl/{{ role_regards_init_master_mservices.front.ssl.key }}
create_env CHECKSUM_RS_FRONT_SSL_KEY {{ role_regards_init_master_config }}regards/nginx/ssl/{{ role_regards_init_master_mservices.front.ssl.crt }}
{% endif %}
{% endif %}


###################################################
################## MICROSERVICE ###################
###################################################

create_env CHECKSUM_RS_MS_APPLICATION_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/application.properties


{% if role_regards_init_master_mservices.access_instance is defined %}
create_env CHECKSUM_RS_ACCESS_INSTANCE_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/access-instance/logback.xml
create_env CHECKSUM_RS_MS_ACCESS_INSTANCE_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-access-instance.properties
{% endif %}

{% if role_regards_init_master_mservices.access_project is defined %}
create_env CHECKSUM_RS_ACCESS_PROJECT_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/access-project/logback.xml
create_env CHECKSUM_RS_MS_ACCESS_PROJECT_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-access-project.properties
{% endif %}

{% if role_regards_init_master_mservices.admin_instance is defined %}
create_env CHECKSUM_RS_ADMIN_INSTANCE_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/admin-instance/logback.xml
create_env CHECKSUM_RS_MS_ADMIN_INSTANCE_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-admin-instance.properties
{% endif %}

{% if role_regards_init_master_mservices.admin is defined %}
create_env CHECKSUM_RS_ADMIN_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/admin/logback.xml
create_env CHECKSUM_RS_MS_ADMIN_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-admin.properties
{% endif %}

{% if role_regards_init_master_mservices.authentication is defined %}
create_env CHECKSUM_RS_AUTHENTICATION_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/authentication/logback.xml
create_env CHECKSUM_RS_MS_AUTHENTICATION_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-authentication.properties
{% endif %}

{% if role_regards_init_master_mservices.catalog is defined %}
create_env CHECKSUM_RS_CATALOG_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/catalog/logback.xml
create_env CHECKSUM_RS_MS_CATALOG_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-catalog.properties
{% endif %}

{% if role_regards_init_master_mservices.config is defined %}
create_env CHECKSUM_RS_CONFIG_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/config/logback.xml
{% endif %}

{% if role_regards_init_master_mservices.dam is defined %}
create_env CHECKSUM_RS_DAM_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/dam/logback.xml
create_env CHECKSUM_RS_MS_DAM_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-dam.properties
{% endif %}

{% if role_regards_init_master_mservices.dataprovider is defined %}
create_env CHECKSUM_RS_DATAPROVIDER_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/dataprovider/logback.xml
create_env CHECKSUM_RS_MS_DATAPROVIDER_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-dataprovider.properties
{% endif %}

{% if role_regards_init_master_mservices.fem is defined %}
create_env CHECKSUM_RS_FEM_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/fem/logback.xml
create_env CHECKSUM_RS_MS_FEM_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-fem.properties
{% endif %}

{% if role_regards_init_master_mservices.gateway is defined %}
create_env CHECKSUM_RS_GATEWAY_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/gateway/logback.xml
create_env CHECKSUM_RS_MS_GATEWAY_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-gateway.properties
{% endif %}

{% if role_regards_init_master_mservices.ingest is defined %}
create_env CHECKSUM_RS_INGEST_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/ingest/logback.xml
create_env CHECKSUM_RS_MS_INGEST_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-ingest.properties
{% endif %}

{% if role_regards_init_master_mservices.lta_manager is defined %}
create_env CHECKSUM_RS_LTA_MANAGER_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/lta-manager/logback.xml
create_env CHECKSUM_RS_MS_LTA_MANAGER_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-lta-manager.properties
{% endif %}

{% if role_regards_init_master_mservices.notifier is defined %}
create_env CHECKSUM_RS_NOTIFIER_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/notifier/logback.xml
create_env CHECKSUM_RS_MS_NOTIFIER_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-notifier.properties
{% endif %}

{% if role_regards_init_master_mservices.order is defined %}
create_env CHECKSUM_RS_ORDER_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/order/logback.xml
create_env CHECKSUM_RS_MS_ORDER_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-order.properties
{% endif %}

{% if role_regards_init_master_mservices.processing is defined %}
create_env CHECKSUM_RS_PROCESSING_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/processing/logback.xml
create_env CHECKSUM_RS_MS_PROCESSING_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-processing.properties
{% endif %}

{% if role_regards_init_master_mservices.registry is defined %}
create_env CHECKSUM_RS_REGISTRY_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/registry/logback.xml
create_env CHECKSUM_RS_MS_REGISTRY_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-registry.properties
{% endif %}

{% if role_regards_init_master_mservices.storage is defined %}
create_env CHECKSUM_RS_STORAGE_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/storage/logback.xml
create_env CHECKSUM_RS_MS_STORAGE_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-storage.properties
{% endif %}

{% if role_regards_init_master_mservices.worker_manager is defined %}
create_env CHECKSUM_RS_WORKER_MANAGER_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/worker-manager/logback.xml
create_env CHECKSUM_RS_MS_WORKER_MANAGER_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-worker-manager.properties
{% endif %}

################# CA CERTS ####################
{% for file in role_regards_init_ca_certificates %}
create_env CHECKSUM_CA_CERT_{{ loop.index0 }} {{ role_regards_init_master_config }}regards/ca-certificates/{{ file }}
{% endfor %}


#############################################
################ WORKER #####################
#############################################

{% if role_regards_init_workers|length %}
create_env CHECKSUM_RS_WORKERS_APPLICATION_YML {{ role_regards_init_master_config }}regards/config/regards-workers/application.yml

{% for worker in role_regards_init_workers %}
{% if worker.config is defined %}
create_env CHECKSUM_WORKER_{{ loop.index0 }}_YML {{ role_regards_init_master_config }}regards/config/regards-workers/{{ worker.name }}.yml
{% endif %}
{% endfor %}
{% endif %}

###########################################
################# COTS ####################
###########################################

################# Postgres ####################
{% if role_regards_init_master_cots.postgres is defined %}
create_env CHECKSUM_RS_POSTGRES_INIT_SQL {{ role_regards_init_master_config }}postgres/init.sql
create_env CHECKSUM_RS_POSTGRES_POSTGRESQL_CONF {{ role_regards_init_master_config }}postgres/postgresql.conf
{% endif %}

################# RabbitMQ ####################
{% if role_regards_init_master_cots.rabbitmq is defined %}
create_env CHECKSUM_RS_RABBITMQ_DEFINITION_JSON {{ role_regards_init_master_config }}rabbitmq/definitions.json
create_env CHECKSUM_RS_RABBITMQ_RABBITMQ_CONF {{ role_regards_init_master_config }}rabbitmq/rabbitmq.conf
{% endif %}

{% if role_regards_init_master_cots.elasticsearch is defined %}
create_env CHECKSUM_RS_ELASTICSEARCH_ELASTICSEARCH_YML {{ role_regards_init_master_config }}elasticsearch/elasticsearch.yml
{% endif %}

{% if role_regards_init_master_cots.elasticsearch_logs is defined %}
create_env CHECKSUM_RS_ELASTICSEARCH_LOGS_ELASTICSEARCH_LOGS_YML {{ role_regards_init_master_config }}elasticsearch/elasticsearch-logs.yml
{% endif %}

{% if role_regards_init_master_cots.fluent is defined %}
create_env CHECKSUM_RS_FLUENT_FLUENT_CONF {{ role_regards_init_master_config }}fluentd/fluent.conf
{% endif %}

#######################################################
################### GLOBAL CONFIGS ####################
#######################################################

{% if role_regards_init_top_level_configs|length %}
{% for config in role_regards_init_top_level_configs %}
create_env CHECKSUM_TOP_LEVEL_CONFIG_FILE_{{ loop.index0 }} {{ role_regards_init_master_config }}mounted/configs/{{ config.path }}/{{ config.file }}
{% endfor %}
{% endif %}

#######################################################
################### GLOBAL SECRETS ####################
#######################################################

{% if role_regards_init_top_level_secrets|length %}
{% for secret in role_regards_init_top_level_secrets %}
create_env CHECKSUM_TOP_LEVEL_SECRET_FILE_{{ loop.index0 }} {{ role_regards_init_master_config }}mounted/secrets/{{ secret.path }}/{{ secret.file }}
{% endfor %}
{% endif %}
