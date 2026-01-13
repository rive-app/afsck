#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"
RIVE_IOS_DIR="$SCRIPT_DIR/../../rive/packages/runtime_ios"

# Build the rive iOS dependencies.
build_rive_ios_deps() {
    pushd "$RIVE_IOS_DIR" > /dev/null || exit 1

    # build_rive.sh is in runtime/build/, so add that to PATH.
    PATH="../runtime/build:$PATH" ./scripts/build.rive.sh ios release
    
    popd > /dev/null
}

build() {
    # For the "post" build, we need to build the rive iOS dependencies first.
    if [[ "$1" == "post" ]]; then
        build_rive_ios_deps
    fi

    pushd "$SCRIPT_DIR/$1" > /dev/null || exit 1
    build_ios
    popd > /dev/null
}

getsize() {
    local runtime="$1"
    local platform="$2"
    local pre_app="$SCRIPT_DIR/pre/build/demo.xcarchive/Products/Applications/demo.app"
    local post_app="$SCRIPT_DIR/post/build/demo.xcarchive/Products/Applications/demo.app"

    # Uncompressed size
    compare_size "$pre_app" "$post_app"
    record_size "$runtime" "$platform" ""
}