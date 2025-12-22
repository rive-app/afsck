#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"

build() {
    pushd "$SCRIPT_DIR/$1" > /dev/null || exit 1
    
    flutter clean
    flutter pub get

    flutter build ios --no-codesign
    flutter build apk

    popd > /dev/null
}

getsize_ios() {
    local pre_app="$SCRIPT_DIR/pre/build/ios/iphoneos/Runner.app"
    local post_app="$SCRIPT_DIR/post/build/ios/iphoneos/Runner.app"
    
    compare_size "$pre_app" "$post_app"
}

getsize_android() {
    local pre_app="$SCRIPT_DIR/pre/build/app/outputs/flutter-apk/app-release.apk"
    local post_app="$SCRIPT_DIR/post/build/app/outputs/flutter-apk/app-release.apk"
    
    compare_size "$pre_app" "$post_app"
}