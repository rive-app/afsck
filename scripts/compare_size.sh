#!/usr/bin/env bash

# Compare the size of two directories/files.
compare_size() {
    PRE_SIZE=$(du -sk "$1" | cut -f1)
    POST_SIZE=$(du -sk "$2" | cut -f1)
    SIZE_DIFF=$((POST_SIZE - PRE_SIZE))
}

# Compare two raw size values (in bytes).
# Converts to KB for consistency with compare_size.
compare_size_raw() {
    PRE_SIZE=$(( $1 / 1024 ))
    POST_SIZE=$(( $2 / 1024 ))
    SIZE_DIFF=$((POST_SIZE - PRE_SIZE))
}