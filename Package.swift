// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "RiksbankAPI",
    platforms: [
        .iOS(.v13), .macOS(.v10_15), .tvOS(.v13)
    ],
    products: [
        .library(name: "RiksbankAPI", targets: ["RiksbankAPI"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RiksbankAPI",
            dependencies: [],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug)),
                .define("RELEASE", .when(configuration: .release)),
                .define("SWIFT_PACKAGE")
            ]),
        .testTarget(name: "RiksbankAPITests", dependencies: ["RiksbankAPI"]),
    ]
)
