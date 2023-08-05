#!/bin/bash

# This script only supports Linux coreutils.
if [[ ${OSTYPE} = darwin* ]]; then
  echo "Mac OS isn't supported, sorry" >&2
  exit 1
fi

# Make sure that the current environment doesn't have it set
if [[ ${_SECRET_TEST} != "" ]]; then
  echo "Environment variable already set... that ain't right!" >&2
  exit 1
fi

# Each output produces tests as described in the readme.
_bash_test=($(_SECRET_TEST=abc ./bash/test.sh))
if (( ${#_bash_test[@]} != 4 )); then
    echo "results from bash test are not correct" >&2
    echo "got ${#_bash_test[@]} results but expected 4" >&2
    echo "_bash_test: ${_bash_test[@]}" >&2
    exit 1
fi


_go_test=($(_SECRET_TEST=abc go run ./go/test.go))
if (( ${#_go_test[@]} != 4 )); then
    echo "results from the Go test are not correct" >&2
    echo "got ${#_go_test[@]} results but expected 4" >&2
    echo "_go_test: ${_go_test[@]}" >&2
    exit 1
fi

_node_test=($(_SECRET_TEST=abc node ./js/test.js))
if (( ${#_node_test[@]} != 4 )); then
    echo "results from the Node test are not correct" >&2
    echo "got ${#_node_test[@]} results but expected 4" >&2
    echo "_node_test: ${_node_test[@]}" >&2
    exit 1
fi

_rust_test=($(cd ./rust && _SECRET_TEST=abc cargo run))
if (( ${#_rust_test[@]} != 4 )); then
    echo "results from the Rust test are not correct" >&2
    echo "got ${#_rust_test[@]} results but expected 4" >&2
    echo "_rust_test: ${_rust_test[@]}" >&2
    exit 1
fi

_python_test=($(_SECRET_TEST=abc python3 python/test.py))
if (( ${#_python_test[@]} != 4 )); then
    echo "results from the Python test are not correct" >&2
    echo "got ${#_python_test[@]} results but expected 4" >&2
    echo "_python_test: ${_python_test[@]}" >&2
    exit 1
fi

_ruby_test=($(_SECRET_TEST=abc ruby ruby/test.rb))
if (( ${#_ruby_test[@]} != 4 )); then
    echo "results from the Ruby test are not correct" >&2
    echo "got ${#_ruby_test[@]} results but expected 4" >&2
    echo "_ruby_test: ${_ruby_test[@]}" >&2
    exit 1
fi

_c_test=($(gcc ./c/test.c -o ./c/test && _SECRET_TEST=abc c/test))
if (( ${#_c_test[@]} != 3 )); then
    echo "results from the C test are not correct" >&2
    echo "got ${#_c_test[@]} results but expected 3" >&2
    echo "_c_test: ${_c_test[@]}" >&2
    exit 1
fi

_c_sharp_test=($(mcs -out:c\#/test.exe c\#/test.cs && _SECRET_TEST=abc mono c\#/test.exe))
if (( ${#_c_sharp_test[@]} != 3 )); then
    echo "results from the C# test are not correct" >&2
    echo "got ${#_c_sharp_test[@]} results but expected 3" >&2
    echo "_c_sharp_test: ${_c_sharp_test[@]}" >&2
    exit 1
fi

echo "Bash: ${_bash_test[@]}"
echo "Go: ${_go_test[@]}"
echo "Node: ${_node_test[@]}"
echo "Rust: ${_rust_test[@]}"
echo "Python: ${_python_test[@]}"
echo "Ruby: ${_ruby_test[@]}"
echo "C: ${_c_test[@]}"
echo "C#: ${_c_sharp_test[@]}"
