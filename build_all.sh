#!/usr/bin/env bash

runtimes=(android ios web web-lite react react-native)

for runtime in "${runtimes[@]}"; do
    echo "Building $runtime..."
    ./runtimes/$runtime/build.sh || exit 1
done