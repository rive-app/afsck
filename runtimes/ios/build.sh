#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"
RIVE_IOS_DIR="$SCRIPT_DIR/../../rive/packages/runtime_ios"

# Build the rive iOS dependencies (C++ runtime, renderers, etc.)
build_rive_ios_deps() {
    pushd "$RIVE_IOS_DIR" > /dev/null || exit 1

    # build_rive.sh is in runtime/build/, so add that to PATH
    PATH="../runtime/build:$PATH" ./scripts/build.rive.sh ios release
    
    popd > /dev/null
}

build() {
    # For the "post" build, we need to build the rive iOS dependencies first.
    if [ "$1" = "post" ]; then
        build_rive_ios_deps
    fi

    cd "$SCRIPT_DIR/$1" || exit 1
    build_ios
    cd "$SCRIPT_DIR"
}

getsize() {
    local pre_app="$SCRIPT_DIR/pre/build/demo.xcarchive/Products/Applications/demo.app"
    local post_app="$SCRIPT_DIR/post/build/demo.xcarchive/Products/Applications/demo.app"

    compare_size "$pre_app" "$post_app"
}