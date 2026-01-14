#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

build() {
    return 0
}

getsize() {
    local runtime="$1"
    local platform="$2"
    local pre_app="$SCRIPT_DIR/pre"
    local post_app="$SCRIPT_DIR/post"

    compare_size "$pre_app" "$post_app"
    record_size "$runtime" "$platform" ""
}

run_build() {
    local runtime="$1"
    local platform="$2"

    build pre
    build post
    getsize "$runtime" "$platform"
}