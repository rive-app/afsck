#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

build() {
    cd "$SCRIPT_DIR/$1" || exit 1
    rm -rf node_modules
    npm install
    npm run build
    cd "$SCRIPT_DIR"
}

getsize() {
    local pre_app="$SCRIPT_DIR/pre/.next"
    local post_app="$SCRIPT_DIR/post/.next"

    compare_size "$pre_app" "$post_app"
}