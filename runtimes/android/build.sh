#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

build() {
    cd "$SCRIPT_DIR/$1" || exit 1
    ./gradlew clean assembleRelease
    cd "$SCRIPT_DIR"
}

getsize() {
    local pre_apk="$SCRIPT_DIR/pre/app/build/outputs/apk/release/app-release-unsigned.apk"
    local post_apk="$SCRIPT_DIR/post/app/build/outputs/apk/release/app-release-unsigned.apk"

    local pre_size=$(stat -f%z "$pre_apk" 2>/dev/null || stat -c%s "$pre_apk" 2>/dev/null)
    local post_size=$(stat -f%z "$post_apk" 2>/dev/null || stat -c%s "$post_apk" 2>/dev/null)

    local diff=$((post_size - pre_size))

    echo "Pre APK size:  $pre_size bytes"
    echo "Post APK size: $post_size bytes"
    echo "Difference:    $diff bytes"
}

build pre
build post
getsize