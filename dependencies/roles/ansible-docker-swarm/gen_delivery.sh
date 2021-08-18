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

# Constant
typeset -r OUTPUT_DIR="${DIR_RACINE}"/target
typeset -r DELIVERY_ARCHIVE_NAME=$(basename "${DIR_RACINE}")

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

cd "${DIR_RACINE}"

# Get version
typeset version
version=$(git describe --tags $(git rev-list --tags --max-count=1))

# Create output dir
mkdir -p "${OUTPUT_DIR}"

tar cfz "${OUTPUT_DIR}"/"${DELIVERY_ARCHIVE_NAME}-${version}".tgz --exclude='.git' \
                                             --exclude='.gitignore' --exclude='target' \
                                             --exclude='.project'  --exclude='gen_delivery.sh' \
                                             --transform "s,^,${DELIVERY_ARCHIVE_NAME}-${version}/," \
                                             .
