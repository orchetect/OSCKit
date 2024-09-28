// swift-tools-version:5.7
// (be sure to update the .swift-version file when this Swift version changes)

import PackageDescription

let package = Package(
    name: "OSCKit",
    
    platforms: [.macOS(.v10_15), .iOS(.v11), .tvOS(.v13)],
    
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
        .package(url: "https://github.com/orchetect/SwiftASCII", from: "1.1.3")
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
            ]
        ),
        .target(
            name: "OSCKitCore",
            dependencies: ["SwiftASCII"]
        ),
        
        // Test targets
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
