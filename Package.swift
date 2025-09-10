// swift-tools-version: 5.9
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "OSCKit",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13)],
    products: products,
    dependencies: dependencies,
    targets: targets
)

var products: [Product] {
    var products: [Product] = []
    
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    products += [
        .library(name: "OSCKit", targets: ["OSCKit"])
    ]
    #endif
    
    products += [
        .library(name: "OSCKitCore", targets: ["OSCKitCore"])
    ]
    return products
}

var dependencies: [Package.Dependency] {
    var dependencies: [Package.Dependency] = []
    
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    dependencies += [
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket", from: "7.0.0")
    ]
    #endif
    
    dependencies += [
        .package(url: "https://github.com/orchetect/SwiftASCII", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-numerics", from: "1.0.2")
    ]
    
    return dependencies
}

var targets: [Target] {
    var targets: [Target] = []
    
    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    targets += [
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
    
    targets += [
        .target(
            name: "OSCKitCore",
            dependencies: ["SwiftASCII"],
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
    
    return targets
}
