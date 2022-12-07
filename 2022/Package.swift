// swift-tools-version: 5.7

import PackageDescription

// Learning Swift via Advent of Code; whee!
let package = Package(
    name: "advent2022",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "advent2022",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),                
                .product(name: "Algorithms", package: "swift-algorithms"),
            ])
    ]
)
