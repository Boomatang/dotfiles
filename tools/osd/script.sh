alias ocm_create="ocm post /api/clusters_mgmt/v1/clusters --body=$OSD_INSTALLATION_DIR/cluster.json"

osd_is_cluster_ready()
{
  CLUSTER_NAME=$1
  if [ $# -eq 0 ]; then
    CLUSTER_NAME=$OSD_CLUSTER_NAME
  fi

  until [[ $(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.display_name==$CLUSTER_NAME).state') = "ready" ]]; do
    STATE=$(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.display_name==$CLUSTER_NAME).state')
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

  CLUSTER_ID=$(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.display_name==$CLUSTER_NAME).id' | tr -d '\"')
  ocm get /api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .kubeconfig > $KUBECONFIG
  echo "OSD config for $CLUSTER_NAME has been set to $KUBECONFIG"
  CONSOLE=$(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.display_name==$CLUSTER_NAME).console.url' | tr -d '\"')
  echo "Console: $CONSOLE"
  echo "Cluster credentials:"
  ocm get /api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq '.admin'
}

osd_get_credentials()
{
  CLUSTER_NAME=$1
  if [ $# -eq 0 ]; then
    CLUSTER_NAME=$OSD_CLUSTER_NAME
  fi

  echo "Getting credentials for $CLUSTER_NAME"
  CLUSTER_ID=$(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.display_name==$CLUSTER_NAME).id' | tr -d '\"')
  
  CONSOLE=$(ocm get /api/clusters_mgmt/v1/clusters | jq -r --arg CLUSTER_NAME "$CLUSTER_NAME" '.items[] | select(.display_name==$CLUSTER_NAME).console.url' | tr -d '\"')
  echo "Console: $CONSOLE"
  ocm get /api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq '.admin'
}

osd_setup()
{
  ocm_create
  osd_is_cluster_ready $1
  osd_setup_credentials $1
}