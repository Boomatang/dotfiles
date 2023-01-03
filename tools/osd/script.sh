alias ocm_create="ocm post /api/clusters_mgmt/v1/clusters --body=$OSD_INSTALLATION_DIR/cluster.json"

osd_is_cluster_ready()
{
  CLUSTER_NAME=$1
  if [ $# -eq 0 ]; then
    CLUSTER_NAME=$OSD_CLUSTER_NAME
  fi

  until [[ $(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.name==$CLUSTER_NAME).state') = "ready" ]]; do
    STATE=$(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.name==$CLUSTER_NAME).state')
    echo "Cluster is not yet ready. STATE: $STATE"
    sleep 30
  done

  echo "Cluster is now ready"
}

osd_setup_credentials()
{
  CLUSTER_NAME=$1
  if [ $# -eq 0 ]; then
    CLUSTER_NAME=$OSD_CLUSTER_NAME
  fi

  CLUSTER_ID=$(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.name==$CLUSTER_NAME).id' | tr -d '\"')
  ocm get /api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .kubeconfig > $KUBECONFIG
  echo "OSD config for $CLUSTER_NAME has been set to $KUBECONFIG"
  CONSOLE=$(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.name==$CLUSTER_NAME).console.url' | tr -d '\"')
  echo "Console: $CONSOLE"
  echo "Cluster credentials:"
  ocm get /api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq '.admin'
}

#osd_get_credentials()
#{
#  CLUSTER_NAME=$1
#  if [ $# -eq 0 ]; then
#    CLUSTER_NAME=$OSD_CLUSTER_NAME
#  fi
#
#  CLUSTER=$(ocm get clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.name==$CLUSTER_NAME)')
#  CLUSTER_ID=$(echo $CLUSTER | jq '.id' | tr -d '\"')
#  CLUSTER_CREDS=$(ocm get /api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq '.admin')
#  CLUSTER_CONSOLE=$(echo $CLUSTER | jq '.console.url' | tr -d '\"')
#  CLUSTER_LOGIN=$(echo $CLUSTER_CONSOLE |cut -d '.' -f 3,4,5,6,7 | cut -d '/' -f 1)
#  echo "Console: $CLUSTER_CONSOLE"
#  echo "Console Login: https://oauth-openshift.apps.$CLUSTER_LOGIN/login?then=%2Foauth%2Fauthorize%3Fclient_id%3Dconsole%26idp%3Dkubeadmin%26redirect_uri%3Dhttps%253A%252F%252Fconsole-openshift-console.apps.$CLUSTER_LOGIN%252Fauth%252Fcallback%26response_type%3Dcode%26scope%3Duser%253Afull"
#  echo $CLUSTER_CREDS | jq
#}

osd_setup()
{
  ocm_create
  osd_is_cluster_ready $1
  osd_setup_credentials $1
}

osd_get_cluster_id()
{
  CLUSTER_NAME=${1}
  if [ $# -eq 0 ]; then
    CLUSTER_NAME=$OSD_CLUSTER_NAME
  fi

  CLUSTER=$(ocm get clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.name==$CLUSTER_NAME)')
  CLUSTER_ID=$(echo $CLUSTER | jq '.id' | tr -d '\"')
  echo ${CLUSTER_ID}
}

osd_delete_addon_rhoam() {
  CLUSTER_NAME=${1}
  if [ $# -eq 0 ]; then
    CLUSTER_NAME=$OSD_CLUSTER_NAME
  fi
  CLUSTER=$(ocm get clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.name==$CLUSTER_NAME)')
  CLUSTER_ID=$(echo $CLUSTER | jq '.id' | tr -d '\"')
  ocm delete /api/clusters_mgmt/v1/clusters/$CLUSTER_ID/addons/managed-api-service
}

function bump_ocm_cluster {
        NAME=$1; CLUSTER=$(ocm get clusters | jq '.items[] | select(.name == "'${NAME}'")');
        DATE=$(date -v +1d +"%Y-%m-%dT%H:%M:%SZ");
        echo "{\"expiration_timestamp\": \"$DATE\"}" | ocm patch /api/clusters_mgmt/v1/clusters/"$(echo $CLUSTER | jq '.id' -r)";
}

ocm_clusterstoragetrue()
{
oc patch rhmi rhoam -n redhat-rhoam-operator --type=merge -p '{"spec":{"useClusterStorage": "true" }}'
}

ocm_extend(){
  # Extends expiration_timestamp of a cluster
  ( set -e; set -o pipefail; # Fail early
    CLUSTER_NAME=${1}
    CLUSTER_ID=$( set -e; set -o pipefail; ocm get clusters --parameter search="display_name like '$CLUSTER_NAME'" | jq -r '.items[].id')
    CLUSTER_CCS=$(ocm get "/api/clusters_mgmt/v1/clusters/${CLUSTER_ID}" | jq -r .ccs.enabled)
    if [ $CLUSTER_CCS != 'true' ]; then
      echo "This command should be used only with BYOC / CCS clusters"
      exit 1
    fi
    echo "Existing timestamp is "
    ocm get /api/clusters_mgmt/v1/clusters/"${CLUSTER_ID}" | jq -r .expiration_timestamp
    echo -e "\nEnter new time stamp"
    read NEW_DATE
    echo "{\"expiration_timestamp\": \"$NEW_DATE\"}" | ocm patch /api/clusters_mgmt/v1/clusters/"$CLUSTER_ID"
    if [ $? -eq 0 ]; then
      echo "Cluster timestamp updated to:"
      ocm get /api/clusters_mgmt/v1/clusters/"${CLUSTER_ID}" | jq -r .expiration_timestamp
    else
      echo "Cluster timestamp update FAILED"
      exit 1
    fi
  )
}

