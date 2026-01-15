#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

build() {
    local flavor="$1"

    pushd "$SCRIPT_DIR/app" > /dev/null || exit 1
    ./gradlew :app:assemble${flavor}Release
    popd > /dev/null
}

getsize() {
    local runtime="$1"
    local platform="$2"
    local pre_app="$SCRIPT_DIR/app/app/build/outputs/apk/default/release/app-default-release-unsigned.apk"
    local post_app="$SCRIPT_DIR/app/app/build/outputs/apk/rive/release/app-rive-release-unsigned.apk"

    compare_size "$pre_app" "$post_app"
    record_size "$runtime" "$platform" ""
}

run_build() {
    local runtime="$1"
    local platform="$2"

    build default
    build rive
    
    getsize "$runtime" "$platform"
}