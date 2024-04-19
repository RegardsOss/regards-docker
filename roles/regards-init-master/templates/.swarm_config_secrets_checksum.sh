#!/bin/bash -e

function get_checksum
{
  printf $(md5sum $1 | cut -f 1 -d " ")
}

function create_env
{
  export "$1=$(get_checksum $2)"
}

{% if role_regards_init_master_mservices_active|bool %}

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

{% if role_regards_init_master_mservices.front.securised is not defined %}
create_env CHECKSUM_RS_FRONT_REGARDS_CONF {{ role_regards_init_master_config }}regards/nginx/regards.conf
{% endif %}

{% if role_regards_init_master_mservices.front.ssl is defined %}
create_env CHECKSUM_RS_FRONT_SSL_CRT {{ role_regards_init_master_config }}regards/nginx/ssl/{{ role_regards_init_master_mservices.front.ssl.key }}
create_env CHECKSUM_RS_FRONT_SSL_KEY {{ role_regards_init_master_config }}regards/nginx/ssl/{{ role_regards_init_master_mservices.front.ssl.crt }}
{% if role_regards_init_master_mservices.front.securised is not defined %}
create_env CHECKSUM_RS_FRONT_BADHOST_CONF {{ role_regards_init_master_config }}regards/nginx/badhost.conf
{%   if role_regards_init_master_mservices.front.rabbitmq_admin is defined %}
create_env CHECKSUM_RS_FRONT_RABBITMQ_CONF {{ role_regards_init_master_config }}regards/nginx/rabbitmq.conf
{%   endif %}
{% endif %}
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

{% if role_regards_init_master_mservices.delivery is defined %}
create_env CHECKSUM_RS_DELIVERY_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/delivery/logback.xml
create_env CHECKSUM_RS_MS_DELIVERY_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-delivery.properties
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

{% if role_regards_init_master_mservices.file_catalog is defined %}
create_env CHECKSUM_RS_FILE_CATALOG_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/file-catalog/logback.xml
create_env CHECKSUM_RS_MS_FILE_CATALOG_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-file-catalog.properties
{% endif %}

{% if role_regards_init_master_mservices.file_access is defined %}
create_env CHECKSUM_RS_FILE_ACCESS_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/file-access/logback.xml
create_env CHECKSUM_RS_MS_FILE_ACCESS_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-file-access.properties
{% endif %}

{% if role_regards_init_master_mservices.file_packager is defined %}
create_env CHECKSUM_RS_FILE_PACKAGER_LOGBACK_XML {{ role_regards_init_master_config }}regards/logback/file-packager/logback.xml
create_env CHECKSUM_RS_MS_FILE_PACKAGER_PROPERTIES {{ role_regards_init_master_config }}regards/config/regards-oss-backend/rs-file-packager.properties
{% endif %}

# End FRONTEND & MICROSERVICES
{% endif %}

################# CA CERTS ####################
{% for file in role_regards_init_ca_certificates %}
create_env CHECKSUM_CA_CERT_{{ file | hash('sha1') }} {{ role_regards_init_master_config }}regards/ca-certificates/{{ file }}
{% endfor %}


#############################################
################ WORKER #####################
#############################################

{% if role_regards_init_workers|length %}
create_env CHECKSUM_RS_WORKERS_APPLICATION_YML {{ role_regards_init_master_config }}regards/config/regards-workers/application.yml

{% for worker in role_regards_init_workers %}
{% if worker.config is defined %}
create_env CHECKSUM_WORKER_{{ worker.name | hash('sha1')  }}_YML {{ role_regards_init_master_config }}regards/config/regards-workers/{{ worker.name }}.yml
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

################# PhpPGAdmin ####################
{% if role_regards_init_master_cots.phppgadmin is defined %}
{%   if role_regards_init_master_cots.phppgadmin.ssl is defined %}
create_env CHECKSUM_RS_PHPPGADMIN_SSL_KEY {{ role_regards_init_master_config }}phppgadmin/ssl/{{ role_regards_init_master_cots.phppgadmin.ssl.key }}
create_env CHECKSUM_RS_PHPPGADMIN_SSL_CRT {{ role_regards_init_master_config }}phppgadmin/ssl/{{ role_regards_init_master_cots.phppgadmin.ssl.crt }}
{%   endif %}
create_env CHECKSUM_RS_PHPPGADMIN_DEFAULT_CONF {{ role_regards_init_master_config }}phppgadmin/default.conf
{%   if role_regards_init_master_cots.phppgadmin.host is defined %}
create_env CHECKSUM_RS_PHPPGADMIN_BADHOST_CONF {{ role_regards_init_master_config }}phppgadmin/badhost.conf
{%   endif %}
{% endif %}


################# RabbitMQ ####################
{% if role_regards_init_master_cots.rabbitmq is defined %}
create_env CHECKSUM_RS_RABBITMQ_RABBITMQ_CONF {{ role_regards_init_master_config }}rabbitmq/rabbitmq.conf
{% endif %}

{% if role_regards_init_master_rabbitmq_global_active|bool %}
create_env CHECKSUM_RS_RABBITMQ_ERLANG_COOKIE {{ role_regards_init_master_config }}rabbitmq/erlang.cookie
{% endif %}


{% if role_regards_init_master_rabbitmq_ssl_active|bool %}
# RabbitMQ SSL
create_env CHECKSUM_RS_RABBITMQ_SSL_CA {{ role_regards_init_master_rabbitmq_folder_certificates }}{{ role_regards_init_master_rabbitmq_ssl_certificates_conf.ca }}
create_env CHECKSUM_RS_RABBITMQ_SSL_CRT {{ role_regards_init_master_rabbitmq_folder_certificates }}{{ role_regards_init_master_rabbitmq_ssl_certificates_conf.crt }}
create_env CHECKSUM_RS_RABBITMQ_SSL_KEY {{ role_regards_init_master_rabbitmq_folder_certificates }}{{ role_regards_init_master_rabbitmq_ssl_certificates_conf.key }}
{% endif %}

################# ElasticSearch ####################
{% if role_regards_init_master_cots.elasticsearch is defined %}
create_env CHECKSUM_RS_ELASTICSEARCH_ELASTICSEARCH_YML {{ role_regards_init_master_config }}elasticsearch/elasticsearch.yml
{% endif %}

################# MinIO ####################
{% if role_regards_init_master_minio_internal_ssl_active|bool %}
create_env CHECKSUM_RS_MINIO_SSL_INT_PUBLIC_CERT {{ role_regards_init_master_config }}minio/certs/{{ role_regards_init_master_minio_ssl_internal_certificates_conf.crt }}
create_env CHECKSUM_RS_MINIO_SSL_INT_PRIVATE_KEY {{ role_regards_init_master_config }}minio/certs/{{ role_regards_init_master_minio_ssl_internal_certificates_conf.key }}
create_env CHECKSUM_RS_MINIO_SSL_INT_CA_TRUST {{ role_regards_init_master_config }}minio/certs/CAs/{{ role_regards_init_master_minio_ssl_internal_certificates_conf.ca }}
{% endif %}
{% if role_regards_init_master_minio_ssl_active|bool %}
create_env CHECKSUM_RS_MINIO_SSL_PUBLIC_CERT {{ role_regards_init_master_config }}minio/certs/{{ role_regards_init_master_minio_ssl_certificates_conf.domain }}/{{ role_regards_init_master_minio_ssl_certificates_conf.crt }}
create_env CHECKSUM_RS_MINIO_SSL_PRIVATE_KEY {{ role_regards_init_master_config }}minio/certs/{{ role_regards_init_master_minio_ssl_certificates_conf.domain }}/{{ role_regards_init_master_minio_ssl_certificates_conf.key }}
{%   if role_regards_init_master_minio_ssl_ca_active|bool %}
create_env CHECKSUM_RS_MINIO_SSL_EXT_CA_TRUST {{ role_regards_init_master_config }}minio/certs/CAs/{{ role_regards_init_master_minio_ssl_certificates_conf.ca }}
{%   endif %}
{% endif %}
{% if role_regards_init_master_minio_mc_log_ca_active|bool %}
create_env CHECKSUM_RS_MINIO_MC_LOG_CA {{ role_regards_init_master_config }}minio/mc/CAs/{{ role_regards_init_master_minio_mc_log_ca }}
{% endif %}


################# HAProxy ####################
{% if role_regards_init_master_cots.haproxy is defined %}
create_env CHECKSUM_RS_HAPROXY_CONFIG_YML {{ role_regards_init_master_config }}haproxy/haproxy.cfg
{% endif %}

{% if role_regards_init_master_cots.elasticsearch_logs is defined %}
create_env CHECKSUM_RS_ELASTICSEARCH_LOGS_ELASTICSEARCH_LOGS_YML {{ role_regards_init_master_config }}elasticsearch/elasticsearch-logs.yml
{% endif %}

################# FluentD ####################

{% if role_regards_init_master_cots.fluent is defined %}
create_env CHECKSUM_RS_FLUENT_FLUENT_CONF {{ role_regards_init_master_config }}fluentd/fluent.conf
{% endif %}

{% if role_regards_init_master_cots.fluentd is defined %}
create_env CHECKSUM_RS_FLUENTD_FLUENT_CONF {{ role_regards_init_master_config }}fluentd/fluent.conf
{% endif %}

################# Grafana ####################
{% if role_regards_init_master_cots.grafana is defined %}
create_env CHECKSUM_RS_GRAFANA_DATASOURCES_YML {{ role_regards_init_master_config }}grafana/datasources.yml
create_env CHECKSUM_RS_GRAFANA_DASHBOARDS_YML {{ role_regards_init_master_config }}grafana/dashboards.yml
create_env CHECKSUM_RS_GRAFANA_GRAFANA_INI {{ role_regards_init_master_config }}grafana/grafana.ini

{%   if role_regards_init_master_cots.grafana.ssl is defined %}
create_env CHECKSUM_RS_GRAFANA_SSL_CRT {{ role_regards_init_master_config }}grafana/ssl/{{ role_regards_init_master_cots.grafana.ssl.key }}
create_env CHECKSUM_RS_GRAFANA_SSL_KEY {{ role_regards_init_master_config }}grafana/ssl/{{ role_regards_init_master_cots.grafana.ssl.crt }}
{%   endif %}

{%   if role_regards_init_master_grafana_active_default_dashboard|bool %}
create_env CHECKSUM_RS_GRAFANA_HOME_JSON {{ role_regards_init_master_config }}grafana/dashboards/home.json
create_env CHECKSUM_RS_GRAFANA_DEMO_JSON {{ role_regards_init_master_config }}grafana/dashboards/demo.json
create_env CHECKSUM_RS_GRAFANA_ELASTICSEARCH_JSON {{ role_regards_init_master_config }}grafana/dashboards/elasticsearch.json
create_env CHECKSUM_RS_GRAFANA_LOKI_LOGS_JSON {{ role_regards_init_master_config }}grafana/dashboards/loki-logs.json
create_env CHECKSUM_RS_GRAFANA_LOKI_MONITORING_JSON {{ role_regards_init_master_config }}grafana/dashboards/loki-monitoring.json
create_env CHECKSUM_RS_GRAFANA_FLUENTD_JSON {{ role_regards_init_master_config }}grafana/dashboards/fluentd.json
create_env CHECKSUM_RS_GRAFANA_MINIO_JSON {{ role_regards_init_master_config }}grafana/dashboards/minio.json
create_env CHECKSUM_RS_GRAFANA_NGINX_JSON {{ role_regards_init_master_config }}grafana/dashboards/nginx.json
create_env CHECKSUM_RS_GRAFANA_NODE_EXPORTER_JSON {{ role_regards_init_master_config }}grafana/dashboards/node-exporter.json
create_env CHECKSUM_RS_GRAFANA_PROMETHEUS_JSON {{ role_regards_init_master_config }}grafana/dashboards/prometheus.json
create_env CHECKSUM_RS_GRAFANA_RABBITMQ_JSON {{ role_regards_init_master_config }}grafana/dashboards/rabbitmq.json
create_env CHECKSUM_RS_GRAFANA_REGARDS_MS_JSON {{ role_regards_init_master_config }}grafana/dashboards/regards_ms.json
create_env CHECKSUM_RS_GRAFANA_CONTAINER_JSON {{ role_regards_init_master_config }}grafana/dashboards/container.json
{%   endif %}
{% endif %}

################# Prometheus ####################
{% if role_regards_init_master_cots.prometheus is defined %}
create_env CHECKSUM_RS_PROMETHEUS_PROMETHEUS_YML {{ role_regards_init_master_config }}prometheus/prometheus.yml
{% endif %}

################# Loki ####################
{% if role_regards_init_master_cots.loki is defined %}
create_env CHECKSUM_RS_LOKI_LOKI_YML {{ role_regards_init_master_config }}loki/loki.yaml
{% endif %}

#######################################################
################### GLOBAL CONFIGS ####################
#######################################################

{% if role_regards_init_top_level_configs|length %}
{% for config in role_regards_init_top_level_configs %}
create_env CHECKSUM_TOP_LEVEL_CONFIG_FILE_{{ (role_regards_init_master_config + "mounted/configs/" + config.path + "/" + config.file) | hash('sha1') }} {{ role_regards_init_master_config }}mounted/configs/{{ config.path }}/{{ config.file }}
{% endfor %}
{% endif %}

#######################################################
################### GLOBAL SECRETS ####################
#######################################################

{% if role_regards_init_top_level_secrets|length %}
{% for secret in role_regards_init_top_level_secrets %}
create_env CHECKSUM_TOP_LEVEL_SECRET_FILE_{{ (role_regards_init_master_config + "mounted/secrets/" + secret.path + "/" + secret.file) | hash('sha1') }} {{ role_regards_init_master_config }}mounted/secrets/{{ secret.path }}/{{ secret.file }}
{% endfor %}
{% endif %}
