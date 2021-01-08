// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	
    name: "OSCKit",
	
    products: [
        .library(
            name: "OSCKit",
            targets: ["OSCKit"]),
    ],
	
    dependencies: [
		.package(url: "https://github.com/orchetect/OTCore", from: "1.0.0"),
		.package(url: "https://github.com/orchetect/SwiftRadix", from: "1.0.0")
		
    ],
	
    targets: [
        .target(
            name: "OSCKit",
            dependencies: ["OTCore", "SwiftRadix"]),
        .testTarget(
            name: "OSCKitTests",
            dependencies: ["OSCKit", "OTCore", "SwiftRadix"]),
    ]
	
)
