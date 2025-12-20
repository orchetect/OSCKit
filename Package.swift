// swift-tools-version: 6.0
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "OSCKit",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13) /* .linux */],
    products: [
        .library(name: "OSCKitCore", targets: ["OSCKitCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/swift-ascii", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-numerics", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "OSCKitCore",
            dependencies: [
                .product(name: "SwiftASCII", package: "swift-ascii")
            ],
            swiftSettings: [.define("DEBUG", .when(configuration: .debug))]
        ),
        .testTarget(
            name: "OSCKitCoreTests",
            dependencies: [
                "OSCKitCore",
                .product(name: "Numerics", package: "swift-numerics")
            ]
        )
    ]
)

// OSCKit Networking Layer Target is currently only available on Apple platforms.
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
package.products += [
    .library(name: "OSCKit", targets: ["OSCKit"])
]

package.dependencies += [
    .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket", from: "7.0.0")
]

package.targets += [
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
    .testTarget(
        name: "OSCKitTests",
        dependencies: ["OSCKit"]
    )
]
#endif

// Documentation Dependency
#if canImport(Foundation)
import class Foundation.ProcessInfo

/// Conditionally opt-in to Swift DocC Plugin when an environment flag is present.
if ProcessInfo.processInfo.environment["ENABLE_DOCC_PLUGIN"] != nil {
    package.dependencies += [
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.4.5")
    ]
}
#endif
