#!/usr/bin/env bash

# Compare the size of two directories.
compare_size() {
    PRE_SIZE=$(du -sk "$1" | cut -f1)
    POST_SIZE=$(du -sk "$2" | cut -f1)
    SIZE_DIFF=$((POST_SIZE - PRE_SIZE))
}