#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

build() {
    pushd "$SCRIPT_DIR/$1" > /dev/null || exit 1
    build_android
    popd > /dev/null
}

getsize() {
    local pre_app="$SCRIPT_DIR/pre/app/build/outputs/apk/release/app-release-unsigned.apk"
    local post_app="$SCRIPT_DIR/post/app/build/outputs/apk/release/app-release-unsigned.apk"

    compare_size "$pre_app" "$post_app"
}