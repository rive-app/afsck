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

get_from_thinning_report() {
    local build_type="$1"
    local key="$2"

    local thinning_report="$SCRIPT_DIR/$build_type/release/demo/app-thinning.plist"

    cat "$thinning_report" | grep "<key>$key</key>" -A 1 | awk 'NR==2' | cut -d ">" -f2 | cut -d "<" -f1
}

getsize() {
    local runtime="$1"
    local platform="$2"

    local pre_size=$(get_from_thinning_report "pre" "sizeUncompressedApp")
    local post_size=$(get_from_thinning_report "post" "sizeUncompressedApp")

    compare_size_raw "$pre_size" "$post_size"
    record_size "$runtime" "$platform" "uncompressed"

    pre_size=$(get_from_thinning_report "pre" "sizeCompressedApp")
    post_size=$(get_from_thinning_report "post" "sizeCompressedApp")

    compare_size_raw "$pre_size" "$post_size"
    record_size "$runtime" "$platform" "compressed"
}

run_build() {
    local runtime="$1"
    local platform="$2"

    build pre
    build post
    getsize "$runtime" "$platform"
}