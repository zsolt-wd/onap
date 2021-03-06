#!/bin/bash

. $(dirname "$0")/setenv.bash


usage() {
  cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
-v [VALUES]         : HELM values filepath (usefull when deploying one component at a time)
-l [LOCATION]       : Location of oom project
-i [INSTANCE]       : ONAP deployment instance # (default: 1)
-a [APP]            : Specify a specific ONAP component (default: all)
                      from the following choices:
                      sdc, aai ,mso, message-router, robot, vid, aaf, uui
                      sdnc, portal, policy, appc, multicloud, clamp, consul, vnfsdk
EOF
}

check_return_code(){
  ret=$?
  if [ $ret -ne 0 ]; then
    printf "The command $1 returned with error code $ret \n" 1>&2
    exit $ret
  fi
}

create_service_account() {
  cmd=`echo kubectl create clusterrolebinding $1-admin-binding --clusterrole=cluster-admin --serviceaccount=$1:default`
  eval ${cmd}
  check_return_code $cmd
}

create_namespace() {
  cmd=`echo kubectl create namespace $1`
  eval ${cmd}
}

create_registry_key() {
cmd=`echo kubectl --namespace $1 create secret docker-registry $2 --docker-server=$3 --docker-username=$4 --docker-password=$5 --docker-email=$6`
  eval ${cmd}
  check_return_code $cmd
}

configure_dcaegen2() {
  if [ ! -s "$OPENSTACK_PRIVATE_KEY_PATH" ]
  then
    echo "ERROR: $OPENSTACK_PRIVATE_KEY_PATH does not exist or is empty.  Cannot launch dcae gen2."
    return 1
  fi

#  cmd=`echo kubectl --namespace $1-$2 create secret generic $2-openstack-ssh-private-key --from-file=key=${OPENSTACK_PRIVATE_KEY_PATH}`
  cmd=`echo kubectl --namespace $1 create secret generic $2-openstack-ssh-private-key --from-file=key=${OPENSTACK_PRIVATE_KEY_PATH}`
  eval ${cmd}
  check_return_code $cmd

  if [ ! -s "$DCAEGEN2_CONFIG_INPUT_FILE_PATH" ]
  then
    echo "ERROR: $DCAEGEN2_CONFIG_INPUT_FILE_PATH does not exist or is empty.  Cannot launch dcae gen2."
    return 1
  fi

#  cmd=`echo kubectl --namespace $1-$2 create configmap $2-config-inputs --from-file=inputs.yaml=${DCAEGEN2_CONFIG_INPUT_FILE_PATH}`
  cmd=`echo kubectl --namespace $1 create configmap $2-config-inputs --from-file=inputs.yaml=${DCAEGEN2_CONFIG_INPUT_FILE_PATH}`
  eval ${cmd}
  check_return_code $cmd
}

create_onap_helm() {
  HELM_VALUES_ADDITION=""
  if [[ ! -z $HELM_VALUES_FILEPATH ]]; then
    HELM_VALUES_ADDITION="--values=$HELM_VALUES_FILEPATH"
  fi
  # Have to put a check for dcaegen2 because it requires external files to helm
  # which should not be part of the Chart.
  if [ "$2" = "dcaegen2" ];
  then
    configure_dcaegen2 $1 $2
    local result=$?
    if [ $result -ne 0 ]
    then
      echo "ERROR: dcaegen2 failed to configure: Pre-requisites not met.  Skipping deploying it and continue"
      return
    fi
  fi

  # assign default auth token
  if [[ -z $ONAP_DEFAULT_AUTH_TOKEN ]]; then
    DEFAULT_SECRET=`kubectl get secrets -n $1 | grep default-token |  awk '{ print $1}'`
    ONAP_DEFAULT_AUTH_TOKEN=`kubectl get secrets $DEFAULT_SECRET -n $1 -o yaml | grep  'token:'  | awk '{ print $2}' | base64 --decode`
  fi

  cmd=`echo helm install $LOCATION/$2/ --name $1-$2 --namespace $1 --set nsPrefix=$1,nodePortPrefix=$3,kubeMasterAuthToken=$ONAP_DEFAULT_AUTH_TOKEN ${HELM_VALUES_ADDITION}`
  eval ${cmd}
  check_return_code $cmd
}

#MAINs
NS=
HELM_VALUES_FILEPATH=""
LOCATION="../"
INCL_SVC=true
APP=
INSTANCE=1
MAX_INSTANCE=5
DU=$ONAP_DOCKER_USER
DP=$ONAP_DOCKER_PASS

SINGLE_COMPONENT=false

while getopts ":n:u:s:i:a:du:dp:l:v:" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    n)
      NS=${OPTARG}
      ;;
    v)
      HELM_VALUES_FILEPATH=${OPTARG}
      ;;
    i)
      INSTANCE=${OPTARG}
      ;;
    l)
      LOCATION=${OPTARG}
      ;;
    a)
      SINGLE_COMPONENT=true
      APP=${OPTARG}
      if [[ -z $APP ]]; then
        usage
        exit 1
      fi
      ;;
    du)
      DU=${OPTARG}
      ;;
    dp)
      DP=${OPTARG}
      ;;
    ?)
      usage
      exit
      ;;
  esac
done

if [[ -z $NS ]]; then
  usage
  exit 1
fi

if [[ ! -z "$APP" ]]; then
  HELM_APPS=($APP)
fi


if [ "$INSTANCE" -gt "$MAX_INSTANCE" ];then
  printf "\n********** You choose to create ${INSTANCE}th instance of ONAP \n"
  printf "\n********** Due to port allocation only ${MAX_INSTANCE} instances of ONAP is allowed per kubernetes deployment\n"
  exit 1
fi

start=$((300+2*INSTANCE))
end=$((start+1))

printf "\n********** Creating instance ${INSTANCE} of ONAP with port range ${start}00 and ${end}99\n"


printf "\n********** Creating ONAP: ${ONAP_APPS[*]}\n"

if [ "$SINGLE_COMPONENT" == "false" ]
then
    printf "\nCreating namespace **********\n"
    create_namespace $NS

    printf "\nCreating registry secret **********\n"
    create_registry_key $NS ${NS}-docker-registry-key $ONAP_DOCKER_REGISTRY $DU $DP $ONAP_DOCKER_MAIL

    printf "\nCreating service account **********\n"
    create_service_account $NS
fi

printf "\n\n********** Creating deployments for ${HELM_APPS[*]} ********** \n"

for i in ${HELM_APPS[@]}; do

  printf "\nCreating deployments and services **********\n"
  create_onap_helm $NS $i $start

  printf "\n"
done

printf "\n**** Done ****\n"
