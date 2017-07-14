#!/bin/bash
# bootstraps linux node with chef client 12.18.31 and adds base roles of g0, g0_w1
# Usage: ./bootstrap_node_base.sh <NODENAME>
NO_ARGS=0
HOST=
ENVIRONMENT=

if [ $# -eq "$NO_ARGS" ]    # Script invoked with no command-line args?
then
  printf "bootstraps linux node with chef client 12.18.31 and adds base roles of g0, g0_w1\nUsage: %s -e prod|beta|dev -h <NODENAME>\n" "$(basename "$0")"
  printf "for multiple hosts seperate them by comma %s -e prod|beta|dev -h <NODE>,<NODE>,<NODE>\n" "$(basename "$0")"
fi

while getopts "e:h:" Option
do
  case $Option in
    e) ENVIRONMENT=${OPTARG};;
    h) HOST=${OPTARG};;
    *) echo "Unimplemented option chosen. Usage: $0 -e prod|beta|dev -h nodename";;   # Default.
  esac
done

shift "$((OPTIND - 1))"

if [[ -n "${HOST}" ]]
  then
  if [[ $HOST == *","* ]]
  then
    echo "Multiple Hosts Supplied:";
    TARGETLIST=(${HOST//,/ })
  else
    echo "Single Host"
    TARGETLIST=$HOST
  fi
  read -rsp "enter root password"$'\n' PASS

  for host in "${TARGETLIST[@]}" ; do
    printf "\n\033[1;31m==========\033[0m\n"
    printf "%s\n" "$host"

    RESOLVABLE=$(ping -c 1 "$host" | wc -l)
    if [[ $RESOLVABLE != '0' ]]
    then
      knife bootstrap "$host" -N "$host" -x 'root' -P "$PASS" -E "$ENVIRONMENT" --bootstrap-version 12.18.31 --bootstrap-vault-json '{"######":["#######"]}'
      knife node run_list add "$host" role[g0],role[g0_w1]
    else
      printf "%s not resolvable in dns, unable to bootstrap\n" "$host"
    fi
  done
fi

