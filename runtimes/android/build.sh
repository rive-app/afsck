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

get_install_size() {
    local flavor="$1"
    local name="$2"

    local apks="$SCRIPT_DIR/app/app/build/outputs/bundle/${flavor}Release/app-$flavor-release.aab.$name.apks"
    local size=$(apkanalyzer apk file-size "$apks")
    echo "$size"
}

get_and_record_size_for_variant() {
    local runtime="$1"
    local platform="$2"
    local flavor1="$3"
    local flavor2="$4"
    local json="$5"
    local name="$6"

    split_bundle $flavor1 "$SCRIPT_DIR/$json" $name
    split_bundle $flavor2 "$SCRIPT_DIR/$json" $name

    local dl_size_default_armv7=$(get_download_size $flavor1 "$SCRIPT_DIR/$json" $name)
    local dl_size_rive_armv7=$(get_download_size $flavor2 "$SCRIPT_DIR/$json" $name)
    local install_size_default_armv7=$(get_install_size $flavor1 $name)
    local install_size_rive_armv7=$(get_install_size $flavor2 $name)

    compare_size_raw "$dl_size_default_armv7" "$dl_size_rive_armv7"
    record_size "$runtime" "$platform" "$name-download"

    compare_size_raw "$install_size_default_armv7" "$install_size_rive_armv7"
    record_size "$runtime" "$platform" "$name-install"
}

run_build() {
    local runtime="$1"
    local platform="$2"

    pushd "$SCRIPT_DIR/app" > /dev/null || exit 1
    ./gradlew clean
    popd > /dev/null

    build default
    build rive
    
    get_and_record_size_for_variant "$runtime" "$platform" "default" "rive" "device_armv7.json" "armv7"
    get_and_record_size_for_variant "$runtime" "$platform" "default" "rive" "device_armv8.json" "armv8"
}