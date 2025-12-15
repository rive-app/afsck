#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

build() {
    cd "$SCRIPT_DIR/$1" || exit 1
    rm -rf node_modules dist
    npm install
    npx expo export --platform android
    npx expo export --platform ios
    # TODO: separate size calculation for Android and iOS
    cd "$SCRIPT_DIR"
}

getsize() {
    local pre_app="$SCRIPT_DIR/pre/dist"
    local post_app="$SCRIPT_DIR/post/dist"

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