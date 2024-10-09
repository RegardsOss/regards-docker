_script()
{
  microservices="rs-storage \
  rs-minio \
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
  rs-delivery \
  rs-file-catalog \
  rs-file-access \
  rs-file-packager \
  lta-sip-generator-worker \
  swot-name-extraction-worker \
  swot-file-extraction-worker \
  feature-mapper-worker \
  local-storage-worker \
  s3-online-storage-worker \
  s3-glacier-storage-worker \
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