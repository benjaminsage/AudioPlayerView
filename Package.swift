// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AudioPlayerView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AudioPlayerView",
            targets: ["AudioPlayerView"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AudioPlayerView",
            dependencies: []
        ),
    ]
)
