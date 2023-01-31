#!/bin/bash -e

printf >&2 "[\033[32mINFO\033[m]\tDeploy REGARDS stack and ensures it runs the last version of all components\n"
printf "To update plugins or change containers versions, please use Ansible-playbook and its inventory\n"
printf "Related documentation: https://regardsoss.github.io/docs/setup/\n\n"

# Handle facultative parameter
if [ $# -ge 1 ]
then
  PULL_OPTION_ARG=$1
  if [ "${PULL_OPTION_ARG}" == "--no-pull-image" ]; then
    removeImageValue="never"
  else
    echo "Syntax: ./deploy.sh [--no-pull-image]"
    exit 1
  fi
else
  removeImageValue="always"
fi

# Load checksum from configs and secrets files
source {{ role_regards_init_master_cli }}.swarm_config_secrets_checksum.sh

docker stack deploy \
  -c {{ role_regards_init_master_stack }}regards-network.yml \
{% if role_regards_init_master_mservices_active|bool %}
  -c {{ role_regards_init_master_stack }}global-mounts.yml \
  -c {{ role_regards_init_master_stack }}regards-stack.yml \
{% endif %}
{% if role_regards_init_master_cots.elasticsearch is defined %}
  -c {{ role_regards_init_master_stack }}elastic.yml \
{% endif %}
{% if role_regards_init_master_cots.elasticsearch_logs is defined or role_regards_init_master_cots.kibana_logs is defined or role_regards_init_master_cots.fluent is defined %}
  -c {{ role_regards_init_master_stack }}logs.yml \
{% endif %}
{% if role_regards_init_master_cots.doc is defined %}
  -c {{ role_regards_init_master_stack }}doc.yml \
{% endif %}
{% if role_regards_init_master_cots.s3_minio is defined %}
  -c {{ role_regards_init_master_stack }}s3-minio.yml \
{% endif %}
{% if role_regards_init_master_cots.maildev is defined %}
  -c {{ role_regards_init_master_stack }}mail.yml \
{% endif %}
{% if role_regards_init_master_cots.postgres is defined or role_regards_init_master_cots.phppgadmin is defined %}
  -c {{ role_regards_init_master_stack }}postgresql.yml \
{% endif %}
{% if role_regards_init_workers | length > 0 %}
  -c {{ role_regards_init_master_stack }}workers.yml \
{% endif %}
{% if role_regards_init_master_cots.rabbitmq is defined %}
  -c {{ role_regards_init_master_stack }}rabbitmq.yml \
{% endif %}
{% if role_regards_init_master_cots.haproxy is defined %}
  -c {{ role_regards_init_master_stack }}haproxy.yml \
{% endif %}
  --with-registry-auth \
  --prune \
  --resolve-image $removeImageValue \
  {{ role_regards_init_master_stack_name }}
