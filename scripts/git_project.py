import sys


def action():
    if len(sys.argv) == 1:
        print("")
        return

    path = sys.argv[1]
    split = path.split(":")
    project = split[1].removesuffix(".git")

    a = f" ({project} | {sys.argv[2]})"
    print(f" ({project} | {sys.argv[2]})")


action()
