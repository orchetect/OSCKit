// swift-tools-version:5.7
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "OSCKit",
    
    platforms: [.macOS(.v10_13), .iOS(.v11), .tvOS(.v11)],
    
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
        .package(url: "https://github.com/orchetect/OTCore", from: "1.4.2"),
        .package(url: "https://github.com/orchetect/SwiftASCII", from: "1.1.3"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.2.0"),
        .package(url: "https://github.com/robbiehanson/CocoaAsyncSocket", from: "7.0.0")
    ],
    
    targets: [
        .target(
            name: "OSCKit",
            dependencies: ["OSCKitCore", "CocoaAsyncSocket"]
        ),
        .target(
            name: "OSCKitCore",
            dependencies: ["OTCore", "SwiftASCII", "SwiftRadix"]
        ),
        
        // Test targets
        .testTarget(
            name: "OSCKitTests",
            dependencies: ["OSCKit", "OTCore"]
        ),
        .testTarget(
            name: "OSCKitCoreTests",
            dependencies: ["OSCKitCore", "OTCore"]
        )
    ]
)

func addShouldTestFlag(toTarget targetName: String) {
    // swiftSettings may be nil so we can't directly append to it
    
    var swiftSettings = package.targets
        .first(where: { $0.name == targetName })?
        .swiftSettings ?? []
    
    swiftSettings.append(.define("shouldTestCurrentPlatform"))
    
    package.targets
        .first(where: { $0.name == targetName })?
        .swiftSettings = swiftSettings
}

func addShouldTestFlags() {
    addShouldTestFlag(toTarget: "OSCKitTests")
    addShouldTestFlag(toTarget: "OSCKitCoreTests")
}

// Swift version in Xcode 12.5.1 which introduced watchOS testing
#if os(watchOS) && swift(>=5.4.2)
addShouldTestFlags()
#elseif os(watchOS)
// don't add flag
#else
addShouldTestFlags()
#endif
