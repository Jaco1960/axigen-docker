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
_link /var/axigen/axigen_cert.pem /var/opt/axigen/axigen_cert.pem
_link /var/axigen/axigen_dh.pem /var/opt/axigen/axigen_dh.pem
_link /var/axigen/domains /var/opt/axigen/domains
_link /var/axigen/filters /var/opt/axigen/filters
_link /var/axigen/kas /var/opt/axigen/kas
_link /var/axigen/kav /var/opt/axigen/kav
_link /var/axigen/log /var/opt/axigen/log
_link /var/axigen/mobile_ua.cfg /var/opt/axigen/mobile_ua.cfg
_link /var/axigen/queue /var/opt/axigen/queue
_link /var/axigen/reporting /var/opt/axigen/reporting
_link /var/axigen/run /var/opt/axigen/run
_link /var/axigen/serverData /var/opt/axigen/serverData
_link /var/axigen/templates /var/opt/axigen/templates
_link /var/axigen/webadmin /var/opt/axigen/webadmin
_link /var/axigen/webmail /var/opt/axigen/webmail

exec "$@"
