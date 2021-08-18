#!/usr/bin/env bash
#
# Copyright 2018-2020, CS GROUP – France, http://www.c-s.fr
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# usage ################################################################
function usage
{
  local -r USAGE_PGR_NAME="$1"
  printf >&2 "Usage : ${USAGE_PGR_NAME} [-h]<-f FQDN><-e email address>[-d alt dns names,...][-p alt ips,...]\n"
  printf >&2 "\t\t-f (Mandatory) : FQDN\n"
  printf >&2 "\t\t-e (Mandatory) : Email Address\n"
  printf >&2 "\t\t-d (Optional) : Alternative DNS Names separeted by commats\n"
  printf >&2 "\t\t-p (Optional) : Alternative IP Names separeted by commats\n"
  printf >&2 "\t\t-o (Optional) : Path to the openssl.cnf file on your system. Defaults to /etc/pki/tls/openssl.cnf\n"
  printf >&2 "\t\t-h (Optional) : Display this help.\n"

  exit 1
}

# end ##################################################################
function end
{
  cd "${DIR}"
}

# main #################################################################

# Set specific options
set -e

typeset -r DIR="$(pwd)"

typeset -r PROCESSUS_NAME=$(basename $0)
typeset -r DIR_RACINE="$(readlink -e "$(dirname $0)")"

typeset result_ok=false

typeset OPENSSL_CNF="/etc/pki/tls/openssl.cnf"

# Restrict PATH
export PATH=/bin:/usr/bin:/sbin:/usr/sbin

# Default configuration

# Declare variables

# Declare constantes
export TARGET_DIR="$(readlink -e "${DIR_RACINE}"/..)/target"
export CERTIFICATES_DIR="$(readlink -e "${DIR_RACINE}"/..)/certificates"
export CRT_PASSPHRASE="lkqsdqdfqkdknflqksnfklqndflknqqqfnnn"
export CA_PASSPHRASE="qflknqknlkqnqeeflknaalkenfalekefn"

echo "${TARGET_DIR}"

while getopts "hf:e:d:p:o:" opt
do
  case ${opt} in
    f)
      typeset -r FQDN="${OPTARG}"
      ;;
    e)
      typeset -r EMAIL_ADDRESS="${OPTARG}"
      ;;
    d)
      typeset -r ALT_DNS_NAME="${OPTARG}"
      ;;
    p)
      typeset -r ALT_IPS="${OPTARG}"
      ;;
    o)
      OPENSSL_CNF="${OPTARG}"
      ;;
    \?|h)
      usage ${PROCESSUS_NAME}
      ;;
  esac
done

shift $((${OPTIND} - 1))

trap end EXIT
set -o pipefail

# Check mandatories parameters
if [ -z "${FQDN}" -o -z "${EMAIL_ADDRESS}" ]
then
  printf >&2 "ERROR : Some mandatory parameters are missing.\n\n"
  usage "${ROOT_WORKINGDIR_PATH}"
fi

mkdir -p "${TARGET_DIR}"
mkdir -p "${CERTIFICATES_DIR}"

typeset alt_dns_name_csr=""
typeset alt_dns_name_crt=""
if [ -n "${ALT_DNS_NAME}" -o -n "${ALT_IPS}" ]
then
  typeset -i i
  typeset -r TMP_ALT_DNS_NAME_CONFIG_FILE_CSR="${TARGET_DIR}"/tmp_alt_dns_name_config_file_csr.txt
  typeset -r TMP_ALT_DNS_NAME_CONFIG_FILE_CRT="${TARGET_DIR}"/tmp_alt_dns_name_config_file_crt.txt
  i=1
  for name in $(echo "${ALT_DNS_NAME}" | sed "s/,/ /g")
  do
    if [ ${i} -eq 1 ]
    then
      cp "${OPENSSL_CNF}" "${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR}"
      alt_dns_name_csr=" -reqexts SAN -config ${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR} "
      alt_dns_name_crt=" -extfile ${TMP_ALT_DNS_NAME_CONFIG_FILE_CRT}"
      printf "\n[SAN]\nsubjectAltName=" >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR}"
      printf "subjectAltName=" > "${TMP_ALT_DNS_NAME_CONFIG_FILE_CRT}"
    else
      printf "," >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR}"
      printf "," >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CRT}"
    fi
    printf "DNS:${name}" >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR}"
    printf "DNS:${name}" >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CRT}"
    i=$(( ${i} + 1 ))
  done
  for ip in $(echo "${ALT_IPS}" | sed "s/,/ /g")
  do
    if [ ${i} -eq 1 ]
    then
      cp "${OPENSSL_CNF}" "${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR}"
      alt_dns_name_csr=" -reqexts SAN -config ${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR} "
      alt_dns_name_crt=" -extfile ${TMP_ALT_DNS_NAME_CONFIG_FILE_CRT}"
      printf "\n[SAN]\nsubjectAltName=" >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR}"
      printf "subjectAltName=" > "${TMP_ALT_DNS_NAME_CONFIG_FILE_CRT}"
    else
      printf "," >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR}"
      printf "," >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CRT}"
    fi
    printf "IP:${ip}" >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR}"
    printf "IP:${ip}" >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CRT}"
    i=$(( ${i} + 1 ))
  done
  printf "\n" >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CSR}"
  printf "\n" >> "${TMP_ALT_DNS_NAME_CONFIG_FILE_CRT}"
fi

# Generate CA
if [ ! -f "${TARGET_DIR}"/ca-key.pem ]
then
  openssl genrsa -aes256 -passout pass:"${CA_PASSPHRASE}" -out "${TARGET_DIR}"/ca-key.pem 4096
fi

if [ ! -f "${CERTIFICATES_DIR}"/ca.pem ]
then
  openssl req -new -x509 -days 36500 -key "${TARGET_DIR}"/ca-key.pem -passin pass:"${CA_PASSPHRASE}" ${alt_dns_name_csr} \
            -subj "/C=FR/ST=OCCITANIE/L=TOULOUSE/O=CS GROUP FRANCE/OU=SPACE/CN=ca/emailAddress=${EMAIL_ADDRESS}" -extensions v3_ca -out "${CERTIFICATES_DIR}"/ca.pem
fi

# Generate Server Certificate
openssl genrsa -out "${CERTIFICATES_DIR}"/server-key-${FQDN}.pem 4096

openssl req -new -key "${CERTIFICATES_DIR}"/server-key-${FQDN}.pem \
        -days 36500 -passout pass:"${CRT_PASSPHRASE}" ${alt_dns_name_csr} \
        -subj "/C=FR/ST=OCCITANIE/L=TOULOUSE/O=CS GROUP FRANCE/OU=SPACE/CN=${FQDN}/emailAddress=${EMAIL_ADDRESS}" \
        -out "${TARGET_DIR}"/${FQDN}.csr

openssl x509 -req -days 36500 -in "${TARGET_DIR}"/${FQDN}.csr ${alt_dns_name_crt} -out "${CERTIFICATES_DIR}"/server-cert-${FQDN}.pem \
             -CA "${CERTIFICATES_DIR}"/ca.pem -CAkey "${TARGET_DIR}"/ca-key.pem -passin pass:"${CA_PASSPHRASE}" \
             -CAcreateserial

exit 0
