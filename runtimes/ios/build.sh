#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

build() {
    cd "$SCRIPT_DIR/$1" || exit 1
    build_ios
    cd "$SCRIPT_DIR"
}

getsize() {
    local pre_app="$SCRIPT_DIR/pre/build/demo.xcarchive/Products/Applications/demo.app"
    local post_app="$SCRIPT_DIR/post/build/demo.xcarchive/Products/Applications/demo.app"

    compare_size "$pre_app" "$post_app"
}