#!/usr/bin/env bash

# Build an iOS project with code signing and generate thinning report.
# Requires DEVELOPMENT_TEAM environment variable to be set.
build_ios() {
    local name="${1:-demo}"

    if [ -z "$DEVELOPMENT_TEAM" ]; then
        echo "Error: DEVELOPMENT_TEAM environment variable not set."
        echo "Find your Team ID with: security find-identity -v -p codesigning"
        echo "Then run: DEVELOPMENT_TEAM=YOUR_TEAM_ID ./build_all.sh"
        return 1
    fi

    # If there is a workspace, use it.
    if [ -d "$name.xcworkspace" ]; then
        # Handle CocoaPods if needed.
        if [ -f "Podfile" ]; then
            pod install
        fi

        xcodebuild archive \
            -workspace "$name.xcworkspace" \
            -scheme "$name" \
            -configuration Release \
            -archivePath "build/$name.xcarchive"
    else
        xcodebuild archive \
            -project "$name.xcodeproj" \
            -scheme "$name" \
            -configuration Release \
            -archivePath "build/$name.xcarchive"
    fi

    # Export archive and generate thinning report.
    mkdir -p "release/$name"
    xcodebuild \
        -exportArchive \
        -archivePath "build/$name.xcarchive" \
        -exportPath "release/$name" \
        -exportOptionsPlist "$SCRIPTS_DIR/exportOptions.plist" \
        -allowProvisioningUpdates
}