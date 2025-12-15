#!/usr/bin/env bash

runtimes=(android ios web web-lite react react-native)

for runtime in "${runtimes[@]}"; do
    ./$runtime/build.sh
done