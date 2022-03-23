#!/usr/bin/env python3

import json
import os
import subprocess
import sys


def get_cluster_credentials(cluster_name):
    """
    Get the login details for the cluster admin
    :param cluster_name:
    :return: console url, {'user': <user>, 'password': <password>, 'api': <api>}
    """
    output = subprocess.run(["ocm", "get", "clusters"], capture_output=True)
    data = json.loads(output.stdout)
    data = data['items']

    found_cluster = None
    for item in data:
        if item['display_name'] == cluster_name:
            found_cluster = item
            break

    if found_cluster is None:
        print(f"No cluster with display name \"{cluster_name}\" was found")
        exit(1)

    cluster_id: str = found_cluster['id']
    cluster_console = found_cluster['console']['url']
    api = found_cluster['api']['url']
    cmd = f"ocm get /api/clusters_mgmt/v1/clusters/{cluster_id}/credentials"
    data = os.popen(cmd)  # don't know why I can't get this to run in subprocess.run
    data = json.loads(data.read())['admin']
    data['api'] = api
    return cluster_console, data


def get_console_login(url):
    return f"Console Login: https://oauth-openshift.apps.{url}/login?then=%2Foauth%2Fauthorize%3Fclient_id%3Dconsole%26idp%3Dkubeadmin%26redirect_uri%3Dhttps%253A%252F%252Fconsole-openshift-console.apps.{url}%252Fauth%252Fcallback%26response_type%3Dcode%26scope%3Duser%253Afull"


def base_url(url):
    spilt = url.split("apps.")
    return spilt[1]


def login_command(creds):
    cmd = ["oc", "login", "-u", creds['user'], "-p", creds['password'], "--server", creds["api"]]
    return ' '.join(cmd)


def print_creds(data):
    print(f'{{\n\t"user": "{data["user"]}",\n\t"password": "{data["password"]}"\n}}')


def print_screen(console_url, data):
    print(f"Console: {console_url}")
    print(f"Console Login: {get_console_login(base_url(console_url))}")
    print(f"Login Command:\n{login_command(data)}")
    print_creds(data)


if __name__ == "__main__":
    if len(sys.argv) == 2:
        tmp_cluster = sys.argv[1]
    else:
        tmp_cluster = os.environ.get("OSD_CLUSTER_NAME")

    console, creds = get_cluster_credentials(tmp_cluster)
    print_screen(console, creds)
