#!/bin/bash -e

printf >&2 "[\033[32mINFO\033[m]\tDeploy REGARDS stack and ensures it runs the last version of all components\n"
printf "To update plugins or change containers versions, please use Ansible-playbook and its inventory\n"
printf "Related documentation: https://regardsoss.github.io/docs/setup/\n\n"

docker stack deploy \
  -c {{ role_regards_init_master_stack }}regards-stack.yml \
  -c {{ role_regards_init_master_stack }}elastic.yml \
{% if role_regards_init_master_cots.elasticsearch_logs is defined or role_regards_init_master_cots.kibana_logs is defined or role_regards_init_master_cots.fluent is defined %}  -c {{ role_regards_init_master_stack }}logs.yml  {% endif %}
{% if role_regards_init_master_cots.doc is defined %}  -c {{ role_regards_init_master_stack }}doc.yml {% endif %}
{% if role_regards_init_master_cots.maildev is defined %}  -c {{ role_regards_init_master_stack }}mail.yml {% endif %}
{% if role_regards_init_master_cots.postgres is defined or role_regards_init_master_cots.phppgadmin is defined %}  -c {{ role_regards_init_master_stack }}postgresql.yml {% endif %}
{% if role_regards_init_workers | length > 0 %} -c {{ role_regards_init_master_stack }}workers.yml {% endif %}
  -c {{ role_regards_init_master_stack }}rabbitmq.yml \
  --with-registry-auth \
  {{ role_regards_init_master_stack_name }}
