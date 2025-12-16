#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

build() {
    cd "$SCRIPT_DIR/$1" || exit 1
    xcodebuild archive \
        -project demo.xcodeproj \
        -scheme demo \
        -configuration Release \
        -archivePath build/demo.xcarchive \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO
    cd "$SCRIPT_DIR"
}

getsize() {
    local pre_app="$SCRIPT_DIR/pre/build/demo.xcarchive/Products/Applications/demo.app"
    local post_app="$SCRIPT_DIR/post/build/demo.xcarchive/Products/Applications/demo.app"

    local pre_size=$(du -sk "$pre_app" | cut -f1)
    local post_size=$(du -sk "$post_app" | cut -f1)

    local diff=$((post_size - pre_size))

    echo "Pre app size:  ${pre_size}K"
    echo "Post app size: ${post_size}K"
    echo "Difference:    ${diff}K"
}

build pre
build post
getsize