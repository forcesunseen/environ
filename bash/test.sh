#!/bin/bash

# Print the environment variable.
echo "_SECRET_TEST=${_SECRET_TEST}"

# Unset the environment variable.
unset _SECRET_TEST

# Print the environment variable after unsetting
echo "_SECRET_TEST=${_SECRET_TEST}"

# Print the environment variable in /proc/self/environ
xargs -0 -L1 -a /proc/self/environ | grep -oP '^_SECRET_TEST=.*$' || echo _SECRET_TEST=

# Print the environment variable from a subprocess
ok=false
e=($(env))
for l in ${e[@]}; do
  if [[ ${l} =~ "_SECRET_TEST" ]]; then
    ok=true
    echo ${l}
  fi
done
if [[ ${ok} == "false" ]]; then
  echo "_SECRET_TEST="
fi
