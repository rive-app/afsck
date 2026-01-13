#!/usr/bin/env bash

CSV_DATA="runtime,platform,variant,pre_kb,post_kb,diff_kb"

# Record the size of the runtime for the given platform and variant.
record_size() {
    local runtime="$1"
    local platform="$2"
    local variant="$3"
    CSV_DATA+=$'\n'"$runtime,$platform,$variant,$PRE_SIZE,$POST_SIZE,$SIZE_DIFF"
}

# Write the CSV data to a file.
write_output_file() {
    echo "$CSV_DATA" > "$ROOT_DIR/afsck_results.csv"
}