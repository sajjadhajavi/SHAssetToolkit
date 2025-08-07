// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SHAssetToolkit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SHAssetToolkit",
            targets: ["SHAssetToolkit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SHAssetToolkit",
            dependencies: []
        ),
    ]
)
