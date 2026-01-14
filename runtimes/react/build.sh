#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

# Build the rive-react dependencies.
build_rive_react() {
    pushd "$SCRIPT_DIR/../../rive-react" > /dev/null || exit 1
    rm -rf node_modules
    npm install
    npm run build
    npm run setup-builds
    popd > /dev/null
}

build() {
    # Build rive-react first for post
    if [[ "$1" == "post" ]]; then
        build_rive_react
    fi

    pushd "$SCRIPT_DIR/$1" > /dev/null || exit 1

    rm -rf node_modules
    npm install
    npm run build

    popd > /dev/null
}

getsize() {
    local runtime="$1"
    local platform="$2"
    local pre_app="$SCRIPT_DIR/pre/.next"
    local post_app="$SCRIPT_DIR/post/.next"

    compare_size "$pre_app" "$post_app"
    record_size "$runtime" "$platform" ""
}