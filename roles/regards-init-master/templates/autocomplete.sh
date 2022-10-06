_script()
{
  microservices="rs-storage \
  rs-s3-minio \
  rs-registry \
  rs-rabbitmq \
  rs-processing \
  rs-postgres \
  rs-phppgadmin \
  rs-order \
  rs-notifier \
  rs-maildev \
  rs-logs-kibana \
  rs-logs-elasticsearch \
  rs-kibana \
  rs-ingest \
  rs-gateway \
  rs-front \
  rs-fluent \
  rs-fem \
  rs-elasticsearch \
  rs-dataprovider \
  rs-dam \
  rs-config \
  rs-catalog \
  rs-authentication \
  rs-admin-instance \
  rs-admin \
  rs-access-project \
  rs-access-instance \
  rs-worker-manager \
  rs-lta-manager \
  lta-sip-generator-worker \
  swot-name-extraction-worker \
  swot-file-extraction-worker \
  feature-mapper-worker \
  simple-worker "
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=( $(compgen -W "$microservices" -- ${cur}) )

  return 0
}
complete -o nospace -F _script ./logs.sh
complete -o nospace -F _script ./update.sh
complete -o nospace -F _script ./reboot.sh
complete -o nospace -F _script ./scale.sh
complete -o nospace -F _script ./exec.sh
complete -o nospace -F _script ./stop.sh