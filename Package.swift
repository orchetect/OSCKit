// swift-tools-version: 5.9
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "OSCKit",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "OSCKit",
            targets: ["OSCKit"]
        ),
        .library(
            name: "OSCKitCore",
            targets: ["OSCKitCore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket", from: "7.0.0"),
        .package(url: "https://github.com/orchetect/SwiftASCII", from: "1.1.5")
    ],
    targets: [
        .target(
            name: "OSCKit",
            dependencies: [
                "OSCKitCore",
                .product(
                    name: "CocoaAsyncSocket",
                    package: "CocoaAsyncSocket",
                    condition: .when(platforms: [.macOS, .macCatalyst, .iOS, .tvOS, .visionOS, .driverKit])
                )
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .target(
            name: "OSCKitCore",
            dependencies: ["SwiftASCII"],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .testTarget(
            name: "OSCKitTests",
            dependencies: ["OSCKit"]
        ),
        .testTarget(
            name: "OSCKitCoreTests",
            dependencies: ["OSCKitCore"]
        )
    ]
)
