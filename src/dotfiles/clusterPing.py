import sys
import os
import yaml
import subprocess
import tempfile
import psutil
from datetime import datetime
from pathlib import Path

def action():
    if len(sys.argv) != 3:
        exit(1)

    kubeconfig = Path(sys.argv[1])
    cluster = sys.argv[2]

    if not kubeconfig.exists() and not kubeconfig.is_file():
        exit(2)

    count = 0
    for process in psutil.process_iter():
        if process.name().startswith("python"):
            cmd = process.cmdline()
            if {str(kubeconfig), cluster} <= set(cmd):
                count += 1

            if count >= 2:
                exit()

    with open(kubeconfig) as kcf:
        kc = yaml.safe_load(kcf)

    if kc is None or not kc.get("current-context", False) == cluster:
        exit(3)

    if kc.get('contexts', None) is None:
        exit()

    c_cluster = None
    for c in kc['contexts']:
        if c['name'] == cluster:
            c_cluster = c['context']['cluster']
            user = c['context']['user']
            break

    if c_cluster is None:
        exit()


    for c in kc['clusters']:
        if c['name'] == c_cluster:
            server = c['cluster']['server']

    if len(server) == 0:
        exit(4)

    for u in kc['users']:
        if u['name'] == user:
            if not u['user']:
                data_file = Path(tempfile.gettempdir(), "cluster_ping.yaml")

                if not data_file.exists():
                    data = {}
                else:
                    with open(data_file) as df:
                        data = yaml.safe_load(df)

                if not str(kubeconfig) in data:
                    data.setdefault(str(kubeconfig), {})

                data[str(kubeconfig)][cluster] = {
                        "connected": False,
                        "checked": str(datetime.now())
                        }

                with open(data_file, "w") as df:
                    df.write(yaml.dump(data))

                exit()

    env = os.environ.copy()
    env["KUBECONFIG"] = kubeconfig
    connected = True

    resp = subprocess.run(["kubectl", "version", "-o", "yaml"], capture_output=True, env=env)
    if len(resp.stderr) != 0:
        connected = False


    data_file = Path(tempfile.gettempdir(), "cluster_ping.yaml")

    if not data_file.exists():
        data = {}
    else:
        with open(data_file) as df:
            data = yaml.safe_load(df)

    if not str(kubeconfig) in data:
        data.setdefault(str(kubeconfig), {})

    data[str(kubeconfig)][cluster] = {
            "connected": connected,
            "checked": str(datetime.now())
            }

    with open(data_file, "w") as df:
        df.write(yaml.dump(data))

if __name__ == "__main__":
    action()
