Note: that you'll need to be logged into ocm here

# Usage
## osd_setup

This creates a cluster and waits for it to be ready. It also sets the kubeconfig and outputs the console link and kubeadmin credentials as soon as the cluster is available
```
export OSD_INSTALLATION_DIR=<path-to-cluster-json-folder>
osd_setup <cluster-name>
```
## ocm_create

This creates an OSD cluster with the config specified in cluster.json file.
```
export OSD_INSTALLATION_DIR=<path-to-cluster-json-folder>
ocm_create
```
## osd_is_cluster_ready

Checks if cluster is ready
```
osd_is_cluster_ready <cluster-name>
```
## osd_setup_credentials

NOTE: Ensure that the cluster is ready first

This sets up the cluster config to your local KUBECONFIG file and returns the kubeadmin credentials
```
osd_setup_credentials <cluster-name>
```
## osd_get_credentials

NOTE: Ensure that the cluster is ready first

This returns the console link and kubeadmin credentials
```
osd_get_credentials <cluster-name>
```

# Credit
The work of this script was done by [JameelB](https://gist.github.com/JameelB) in this [gist](https://gist.github.com/JameelB/8dd57bdf26a3df42535e09390ad1c85a)