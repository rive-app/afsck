#!/usr/bin/env bash

# Build an iOS project.
build_ios() {
    local name="${1:-demo}"

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
            -archivePath "build/$name.xcarchive" \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO
    else
        xcodebuild archive \
            -project "$name.xcodeproj" \
            -scheme "$name" \
            -configuration Release \
            -archivePath "build/$name.xcarchive" \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO \
            CODE_SIGNING_ALLOWED=NO
    fi
}