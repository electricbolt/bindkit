#!/bin/bash

set -e

IOSSDK_VER="17.5"
# xcodebuild -showsdks

echo ""
echo "******************************************************"
echo ""
echo "Compiling framework source for iOS"
echo ""
echo "******************************************************"
echo ""

rm -rf BindKit.xcframework
cd BindKit
rm -rf build

xcodebuild clean build -sdk iphonesimulator${IOSSDK_VER}  BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO ONLY_ACTIVE_ARCH=NO VALID_ARCHS="x86_64 arm64" -project BindKit.xcodeproj -scheme "BindKit" -configuration Release -derivedDataPath ./build/build-iphonesimulator
xcodebuild clean build -sdk iphoneos${IOSSDK_VER}  BUILD_LIBRARY_FOR_DISTRIBUTION=YES SKIP_INSTALL=NO ONLY_ACTIVE_ARCH=NO VALID_ARCHS="arm64" -project BindKit.xcodeproj -scheme "BindKit" -configuration Release -derivedDataPath ./build/build-iphoneos

cd build

echo ""
echo "******************************************************"
echo ""
echo "Creating xcframework"
echo ""
echo "******************************************************"
echo ""

xcodebuild -create-xcframework \
    -framework build-iphonesimulator/Build/Products/Release-iphonesimulator/BindKit.framework \
    -framework build-iphoneos/Build/Products/Release-iphoneos/BindKit.framework \
    -output BindKit.xcframework

echo ""
echo "******************************************************"
echo ""
echo "Signing xcframework"
echo ""
echo "******************************************************"
echo ""

codesign --timestamp -v --sign "Apple Distribution: Electric Bolt Limited (KLCLPVKM8C)" BindKit.xcframework

echo ""
echo "******************************************************"
echo ""
echo "Copying xcframework"
echo ""
echo "******************************************************"
echo ""

cd ../..

cp -R BindKit/build/BindKit.xcframework BindKit.xcframework
rm -rf BindKit/build

echo "Finished"
