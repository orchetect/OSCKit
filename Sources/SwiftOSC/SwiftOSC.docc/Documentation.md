# ``SwiftOSC``

Open Sound Control (OSC) toolkit written in Swift for Apple platforms, Linux, and Android.

## Overview

![SwiftOSC](swift-osc-banner.png)

- OSC address pattern matching and dispatch
- Convenient OSC message value type masking, validation and strong-typing
- Modular: use one of the provided TCP/UDP network I/O layers, or implement your own
- Support for custom OSC types
- Supports Swift 6 Concurrency
- Fully unit tested
- Full DocC documentation

## Getting Started

Getting started with using SwiftOSC in your application.

### Import the Library

Import the library using the default cross-platform network I/O extension:

```swift
import SwiftOSC
```

> Tip:
>
> To use SwiftOSC core types without networking I/O in order to implement your own sockets,
> use [**swift-osc-core**](https://github.com/orchetect/swift-osc-core) as a dependency instead of **swift-osc**.
>
> You may also use any of the alternative network I/O extensions available instead of the default by using any of them as a dependency directly instead of **swift-osc**.
> See the [`SwiftOSC` README file](https://github.com/orchetect/swift-osc) for links to all available extensions. 

### Value Types

- See [OSC Value Types](https://swiftpackageindex.com/orchetect/swift-osc-core/documentation/swiftosccore/osc-value-types) in the SwiftOSCCore package documentation.

### Sending and Receiving (I/O)

- See the I/O [Getting Started guide](https://swiftpackageindex.com/orchetect/swift-osc-core/documentation/swiftosciocore/getting-started) in the SwiftOSCCore repository.

### Example Code

- See the [Examples](https://github.com/orchetect/swift-osc/tree/main/Examples) folder in the main SwiftOSC repository for a demonstration of how to use SwiftOSC's core types and I/O.
