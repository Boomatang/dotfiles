import sys
import psutil
import yaml
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

    if kc is None or not kc["current-context"] == cluster:
        exit(3)

    if kc['contexts'] is None:
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
            if u['user']:
                return True
    return False
        
        
if __name__ == "__main__":
    action()
        