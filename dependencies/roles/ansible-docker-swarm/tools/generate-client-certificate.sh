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
  printf >&2 "Usage : ${USAGE_PGR_NAME} [-h]\n"
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

# Restrict PATH
export PATH=/bin:/usr/bin:/sbin:/usr/sbin

# Default configuration

# Declare variables

# Declare constantes
export TARGET_DIR="$(readlink -e "${DIR_RACINE}"/..)/target"
export CERTIFICATES_DIR="$(readlink -e "${DIR_RACINE}"/..)/certificates"
export CA_PASSPHRASE="qflknqknlkqnqeeflknaalkenfalekefn"

while getopts "h" opt
do
  case ${opt} in
    \?|h)
      usage ${PROCESSUS_NAME}
      ;;
  esac
done

shift $((${OPTIND} - 1))

trap end EXIT
set -o pipefail

# Check mandatories parameters

mkdir -p "${TARGET_DIR}"
mkdir -p "${CERTIFICATES_DIR}"

# Generate Client Certificate
openssl genrsa -out "${CERTIFICATES_DIR}"/key-client.pem 4096
openssl req -subj '/CN=client' -new -key "${CERTIFICATES_DIR}"/key-client.pem -out "${TARGET_DIR}"/client.csr
printf "extendedKeyUsage = clientAuth\n" > "${TARGET_DIR}"/extfile-client.cnf
openssl x509 -req -days 36500 -sha256 -in "${TARGET_DIR}"/client.csr -CA "${CERTIFICATES_DIR}"/ca.pem -CAkey "${TARGET_DIR}"/ca-key.pem -passin pass:"${CA_PASSPHRASE}" -CAcreateserial -out "${CERTIFICATES_DIR}"/cert-client.pem -extfile "${TARGET_DIR}"/extfile-client.cnf
rm -f "${CERTIFICATES_DIR}"/ca.srl

exit 0
