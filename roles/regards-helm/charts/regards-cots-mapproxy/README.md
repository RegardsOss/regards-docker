helm install mapproxy playbooks/helm/cots/mapproxy \
  --namespace regards \
  --set-file mapserver.mapfiles.awsCredentials=aws_credentials.inc.map.sample \
  --set-file mapserver.mapfiles.postgresConnection=postgres_connection.inc.map.sample

TODO: replace *.sample files by actual files. See the samples for inspiration.