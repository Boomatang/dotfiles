import sys

def action():
    if len(sys.argv) == 1:
        print("")
        return

    path = sys.argv[1]
    split = path.split(":")
    try:
        project = split[1].removesuffix(".git")
    except AttributeError:
        if split[1].endswith(".git"):
            project = split[1][:-4]
    a = f" ({project} | {sys.argv[2]})"
    print(f" ({project} | {sys.argv[2]})")

action()
