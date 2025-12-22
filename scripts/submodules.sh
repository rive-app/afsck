#!/usr/bin/env bash

# Reset and clean all submodules.
update_submodules() {
    git submodule update --init --recursive --remote
    git submodule foreach --recursive 'git reset --hard && git clean -fdx'
}