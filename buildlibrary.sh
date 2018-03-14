#!/bin/bash

set -e

IOSSDK_VER="11.2"
# xcodebuild -showsdks

echo Compiling library source

rm -rf ./lib
mkdir release
cd BindKit
rm -rf ./build

# iOS
xcodebuild clean build -sdk iphonesimulator${IOSSDK_VER} -arch "i386" ONLY_ACTIVE_ARCH=NO VALID_ARCHS="i386 x86_64" -project BindKit.xcodeproj -scheme "BindKit" -configuration Release -derivedDataPath ./build/build-i386
xcodebuild clean build -sdk iphonesimulator${IOSSDK_VER} -arch "x86_64" ONLY_ACTIVE_ARCH=NO VALID_ARCHS="i386 x86_64" -project BindKit.xcodeproj -scheme "BindKit" -configuration Release -derivedDataPath ./build/build-x86_64
xcodebuild clean build -sdk iphoneos${IOSSDK_VER} -arch "armv7s" ONLY_ACTIVE_ARCH=NO VALID_ARCHS="armv7s armv7 arm64" -project BindKit.xcodeproj -scheme "BindKit" -configuration Release -derivedDataPath ./build/build-armv7s
xcodebuild clean build -sdk iphoneos${IOSSDK_VER} -arch "armv7" ONLY_ACTIVE_ARCH=NO VALID_ARCHS="armv7s armv7 arm64" -project BindKit.xcodeproj -scheme "BindKit" -configuration Release -derivedDataPath ./build/build-armv7
xcodebuild clean build -sdk iphoneos${IOSSDK_VER} -arch "arm64" ONLY_ACTIVE_ARCH=NO VALID_ARCHS="armv7s armv7 arm64" -project BindKit.xcodeproj -scheme "BindKit" -configuration Release -derivedDataPath ./build/build-arm64

cd build

echo Creating fat library for iOS

xcrun -sdk iphoneos lipo -create build-i386/Build/Products/Release-iphonesimulator/libBindKit.a \
                                 build-x86_64/Build/Products/Release-iphonesimulator/libBindKit.a \
                                 build-armv7s/Build/Products/Release-iphoneos/libBindKit.a \
                                 build-armv7/Build/Products/Release-iphoneos/libBindKit.a \
                                 build-arm64/Build/Products/Release-iphoneos/libBindKit.a \
                         -output libBindKit.a
cd ../..
cp BindKit/build/libBindKit.a release
cp BindKit/BindKit/public/BindKit.h release
cp BindKit/BindKit/public/BindKitVendor.h release

rm -rf BindKit/BindKit/build

echo Finished
