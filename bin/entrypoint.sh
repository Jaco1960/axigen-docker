#!/bin/bash

_link() {
  if [[ -L ${2} && $(readlink ${2}) == ${1} ]]; then
    return 0
  fi
  if [[ ! -e ${1} ]]; then
    if [[ -d ${2} ]]; then
      mkdir -p "${1}"
      pushd ${2} &>/dev/null
      find . -type f -exec cp --parents '{}' "${1}/" \;
      popd &>/dev/null
    elif [[ -f ${2} ]]; then
      if [[ ! -d $(dirname ${1}) ]]; then
        mkdir -p $(dirname ${1})
      fi
      cp -f "${2}" "${1}"
    else
      mkdir -p "${1}"
    fi
  fi
  if [[ -d ${2} ]]; then
    rm -rf "${2}"
  elif [[ -f ${2} || -L ${2} ]]; then
    rm -f "${2}"
  fi
  if [[ ! -d $(dirname ${2}) ]]; then
    mkdir -p $(dirname ${2})
  fi
  ln -sf ${1} ${2}
}

# move axigen files out of container
_link /var/axigen  /var/opt/axigen

exec "$@