#!/usr/bin/env bash

ROOT_DIR="$(dirname "$(realpath "$BASH_SOURCE")")"
SCRIPTS_DIR="$ROOT_DIR/scripts"

if [ -z "$ANDROID_HOME" ]; then
    echo "ANDROID_HOME must be set to the path to the Android SDK!"
    exit 1
fi

# Source all build scripts.
source "$SCRIPTS_DIR/build_ios.sh"
source "$SCRIPTS_DIR/compare_size.sh"
source "$SCRIPTS_DIR/output_file.sh"
source "$SCRIPTS_DIR/submodules.sh"

# Runtime build information.
runtimes=(android ios web web-lite react)
multiplatform_runtimes=(react-native flutter)

build_runtime() {
    local runtime_dir="$ROOT_DIR/runtimes/$1"
    source "$runtime_dir/build.sh"

    # Runtime handles its own build and size recording
    run_build "$1" "$1"

    cleanup
}

build_multiplatform_runtime() {
    local runtime_dir="$ROOT_DIR/runtimes/$1"
    source "$runtime_dir/build.sh"

    # Runtime handles its own build and size recording for both platforms
    run_build "$1"

    cleanup
}

cleanup() {
    unset -f run_build build getsize getsize_ios getsize_android
    unset PRE_SIZE POST_SIZE SIZE_DIFF
    unset SCRIPT_DIR
}

echo "======== Updating submodules ========"
update_submodules

# If no targets are specified, build all runtimes and multiplatform runtimes.
TARGETS=("$@")
if [ -z "$TARGETS" ]; then
    TARGETS=("${runtimes[@]}" "${multiplatform_runtimes[@]}")
fi

for target in "${TARGETS[@]}"; do
    echo "======== Building $target ========"
    if [[ "${runtimes[@]}" =~ "$target" ]]; then
        build_runtime "$target"
    elif [[ "${multiplatform_runtimes[@]}" =~ "$target" ]]; then
        build_multiplatform_runtime "$target"
    else
        echo "Unknown target: $target"
        exit 1
    fi
done

write_output_file