#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

build() {
    local flavor="$1"

    pushd "$SCRIPT_DIR/app" > /dev/null || exit 1
    ./gradlew :app:bundle${flavor}Release
    popd > /dev/null
}

split_bundle() {
    local flavor="$1"
    local json="$2"
    local name="$3"

    local bundle="$SCRIPT_DIR/app/app/build/outputs/bundle/${flavor}Release/app-$flavor-release.aab"
    bundletool build-apks --bundle="$bundle" --output="$bundle.$name.apks" --device-spec="$json"
}

get_download_size() {
    local flavor="$1"
    local json="$2"
    local name="$3"

    local apks="$SCRIPT_DIR/app/app/build/outputs/bundle/${flavor}Release/app-$flavor-release.aab.$name.apks"
    local size=$(bundletool get-size total --apks="$apks" --device-spec="$json" --dimensions=ALL)
    echo "$size" | awk -F ',' '{ print $13 }' | tail -1 | tr -d '[:space:]'
}

run_build() {
    local runtime="$1"
    local platform="$2"

    # pushd "$SCRIPT_DIR/app" > /dev/null || exit 1
    # ./gradlew clean
    # popd > /dev/null

    # build default
    # build rive

    split_bundle default "$SCRIPT_DIR/device_armv7.json" armv7
    split_bundle rive "$SCRIPT_DIR/device_armv7.json" armv7
    local dl_size_default_armv7=$(get_download_size default "$SCRIPT_DIR/device_armv7.json" armv7)
    local dl_size_rive_armv7=$(get_download_size rive "$SCRIPT_DIR/device_armv7.json" armv7)

    compare_size_raw "$dl_size_default_armv7" "$dl_size_rive_armv7"
    record_size "$runtime" "$platform" "armv7"

    split_bundle default "$SCRIPT_DIR/device_armv8.json" armv8
    split_bundle rive "$SCRIPT_DIR/device_armv8.json" armv8
    local dl_size_default_armv8=$(get_download_size default "$SCRIPT_DIR/device_armv8.json" armv8)
    local dl_size_rive_armv8=$(get_download_size rive "$SCRIPT_DIR/device_armv8.json" armv8)

    compare_size_raw "$dl_size_default_armv8" "$dl_size_rive_armv8"
    record_size "$runtime" "$platform" "armv8"
}