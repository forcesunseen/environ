#!/usr/bin/env python3

import os
import subprocess

print("_SECRET_TEST={}".format(os.environ.get("_SECRET_TEST")))
del os.environ["_SECRET_TEST"]
print("_SECRET_TEST={}".format(os.environ.get("_SECRET_TEST")))

f = open("/proc/self/environ", "r")
d = f.read().split("\0")
f.close()
print(d[0])

ok = False
x = subprocess.check_output(["env"], shell=True).decode("utf-8")
for line in x.split("\n"):
    if line.startswith("_SECRET_TEST"):
        ok = True
        print(line)
if ok == False:
    print("_SECRET_TEST=")
