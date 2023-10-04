##!/bin/sh

xcrun xcodebuild docbuild \
    -scheme Basic-Car-Maintenance \
    -destination 'generic/platform=iOS Simulator' \
    -derivedDataPath "$PWD/.derivedData"

xcrun docc process-archive transform-for-static-hosting \
    "$PWD/.derivedData/Build/Products/Debug-iphonesimulator/Basic-Car-Maintenance.doccarchive" \
    --output-path ".docs" \
    --hosting-base-path "https://mikaelacaron.github.io/Basic-Car-Maintenance"

echo '<script>window.location.href += "/documentation/Basic_Car_Maintenance"</script>' > .docs/index.html


