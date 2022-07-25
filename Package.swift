// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    
    name: "OSCKit",
    
    platforms: [.macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)],
    
    products: [
        .library(
            name: "OSCKit",
            targets: ["OSCKit"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/orchetect/OTCore", from: "1.4.1"),
        .package(url: "https://github.com/orchetect/SwiftASCII", from: "1.1.3"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.2.0")
    ],
    
    targets: [
        .target(
            name: "OSCKit",
            dependencies: ["OTCore", "SwiftASCII", "SwiftRadix"]),
        .testTarget(
            name: "OSCKitTests",
            dependencies: ["OSCKit", "OTCore", "SwiftASCII", "SwiftRadix"]),
    ]
    
)

func addShouldTestFlag() {
    // swiftSettings may be nil so we can't directly append to it
    
    var swiftSettings = package.targets
        .first(where: { $0.name == "OSCKitTests" })?
        .swiftSettings ?? []
    
    swiftSettings.append(.define("shouldTestCurrentPlatform"))
    
    package.targets
        .first(where: { $0.name == "OSCKitTests" })?
        .swiftSettings = swiftSettings
}

// Swift version in Xcode 12.5.1 which introduced watchOS testing
#if os(watchOS) && swift(>=5.4.2)
addShouldTestFlag()
#elseif os(watchOS)
// don't add flag
#else
addShouldTestFlag()
#endif
