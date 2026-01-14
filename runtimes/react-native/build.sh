#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

# Build the rive-react-native dependencies.
build_rive_react_native() {
    pushd "$SCRIPT_DIR/../../rive-react-native" > /dev/null || exit 1
    rm -rf node_modules lib
    yarn install
    yarn prepare
    popd > /dev/null
}

build() {
    # Build rive-react-native first for post.
    if [[ "$1" == "post" ]]; then
        build_rive_react_native
    fi

    pushd "$SCRIPT_DIR/$1" > /dev/null || exit 1
    rm -rf node_modules dist
    rm -rf android ios
    npm install
    EXPO_NO_GIT_STATUS=1 npx expo prebuild --clean
    
    pushd ios > /dev/null || exit 1
    build_ios
    popd > /dev/null

    pushd android > /dev/null || exit 1
    build_android
    popd > /dev/null

    popd > /dev/null
}

getsize_ios() {
    local runtime="$1"
    local platform="$2"
    local pre_app="$SCRIPT_DIR/pre/ios/build/demo.xcarchive/Products/Applications/demo.app"
    local post_app="$SCRIPT_DIR/post/ios/build/demo.xcarchive/Products/Applications/demo.app"
    
    compare_size "$pre_app" "$post_app"
    record_size "$runtime" "$platform" ""
}

getsize_android() {
    local runtime="$1"
    local platform="$2"
    local pre_app="$SCRIPT_DIR/pre/android/app/build/outputs/apk/release/app-release.apk"
    local post_app="$SCRIPT_DIR/post/android/app/build/outputs/apk/release/app-release.apk"
    
    compare_size "$pre_app" "$post_app"
    record_size "$runtime" "$platform" ""
}

run_build() {
    local runtime="$1"

    build pre
    build post
    getsize_ios "$runtime" "ios"
    getsize_android "$runtime" "android"
}