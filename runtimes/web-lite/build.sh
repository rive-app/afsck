#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(realpath "$0")")"

getsize() {
    local pre_app="$SCRIPT_DIR/pre"
    local post_app="$SCRIPT_DIR/post"

    local pre_size=$(du -sk "$pre_app" | cut -f1)
    local post_size=$(du -sk "$post_app" | cut -f1)

    local diff=$((post_size - pre_size))

    echo "Pre app size:  ${pre_size}K"
    echo "Post app size: ${post_size}K"
    echo "Difference:    ${diff}K"
}

getsize