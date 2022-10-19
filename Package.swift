// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AKLanguageManager",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "AKLanguageManager",
            targets: ["AKLanguageManager"]),
    ],
    targets: [
        .target(
            name: "AKLanguageManager",
            dependencies: []),
        .testTarget(
            name: "AKLanguageManagerTests",
            dependencies: ["AKLanguageManager"],
            resources: [
              .process("Resources"),
            ]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
