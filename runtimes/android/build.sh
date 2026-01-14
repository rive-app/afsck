#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

build() {
    pushd "$SCRIPT_DIR/$1" > /dev/null || exit 1
    build_android
    popd > /dev/null
}

getsize() {
    local runtime="$1"
    local platform="$2"
    local pre_app="$SCRIPT_DIR/pre/app/build/outputs/apk/release/app-release-unsigned.apk"
    local post_app="$SCRIPT_DIR/post/app/build/outputs/apk/release/app-release-unsigned.apk"

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