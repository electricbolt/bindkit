// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "BindKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BindKit",
            targets: ["BindKit"])
    ],
    targets: [
        .binaryTarget(
            name: "BindKit",
            path: "BindKit.xcframework"
        )
    ]
)
