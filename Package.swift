// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "OTTableView",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "OTTableView",
            targets: ["OTTableView"]),
    ],
    dependencies: [
        // none
    ],
    targets: [
        .target(
            name: "OTTableView",
            dependencies: []),
        .testTarget(
            name: "OTTableViewTests",
            dependencies: ["OTTableView"]),
    ]
)
