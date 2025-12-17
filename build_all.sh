#!/usr/bin/env bash

ROOT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"
SCRIPTS_DIR="$ROOT_DIR/scripts"

# Temporary: set the ANDROID_HOME environment variable.
ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_HOME

if [ -z "$ANDROID_HOME" ]; then
    echo "ANDROID_HOME must be set to the path to the Android SDK!"
    exit 1
fi

# Source all build scripts.
source "$SCRIPTS_DIR/build_android.sh"
source "$SCRIPTS_DIR/build_ios.sh"
source "$SCRIPTS_DIR/compare_size.sh"

runtimes=(android ios web web-lite react)
build_runtime() {
    local runtime_dir="$ROOT_DIR/runtimes/$1"
    source "$runtime_dir/build.sh"
    build pre
    build post
    getsize

    echo "$1: Pre=$PRE_SIZE, Post=$POST_SIZE, Diff=$SIZE_DIFF"

    cleanup
}

multiplatform_runtimes=(react-native flutter)
build_multiplatform_runtime() {
    local runtime_dir="$ROOT_DIR/runtimes/$1"
    source "$runtime_dir/build.sh"
    build pre
    build post

    getsize_ios
    echo "iOS $1: Pre=$PRE_SIZE, Post=$POST_SIZE, Diff=$SIZE_DIFF"

    getsize_android
    echo "Android $1: Pre=$PRE_SIZE, Post=$POST_SIZE, Diff=$SIZE_DIFF"

    cleanup
}

cleanup() {
    unset -f build getsize getsize_ios getsize_android
    unset PRE_SIZE POST_SIZE SIZE_DIFF
    unset SCRIPT_DIR
}

for runtime in "${runtimes[@]}"; do
    echo "======== Building $runtime ========"
    build_runtime $runtime
done

for runtime in "${multiplatform_runtimes[@]}"; do
    echo "======== Building $runtime ========"
    build_multiplatform_runtime $runtime
done