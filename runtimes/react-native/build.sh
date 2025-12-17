#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

build() {
    cd "$SCRIPT_DIR/$1" || exit 1
    rm -rf node_modules dist
    rm -rf android ios
    npm install
    EXPO_NO_GIT_STATUS=1 npx expo prebuild --clean
    
    cd ios
    build_ios
    cd ..

    cd android
    build_android
    cd ..

    cd "$SCRIPT_DIR"
}

getsize_ios() {
    local pre_app="$SCRIPT_DIR/pre/ios/build/demo.xcarchive/Products/Applications/demo.app"
    local post_app="$SCRIPT_DIR/post/ios/build/demo.xcarchive/Products/Applications/demo.app"
    
    compare_size "$pre_app" "$post_app"
}

getsize_android() {
    local pre_app="$SCRIPT_DIR/pre/android/app/build/outputs/apk/release/app-release.apk"
    local post_app="$SCRIPT_DIR/post/android/app/build/outputs/apk/release/app-release.apk"
    
    compare_size "$pre_app" "$post_app"
}