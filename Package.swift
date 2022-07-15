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
        .package(url: "https://github.com/orchetect/OTCore", from: "1.1.28"),
        .package(url: "https://github.com/orchetect/SwiftASCII", from: "1.0.2"),
        .package(url: "https://github.com/orchetect/SwiftRadix", from: "1.0.3")
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
