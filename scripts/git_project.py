import sys


def action():
    if len(sys.argv) == 1:
        print("")
        return

    path = sys.argv[1]
    split = path.split(":")
    if len(split) < 2:
        print(f" ({sys.argv[1]})")
    else:
        project = split[1].removesuffix(".git")

        a = f" ({project} | {sys.argv[2]})"
        print(f" ({project} | {sys.argv[2]})")


action()
