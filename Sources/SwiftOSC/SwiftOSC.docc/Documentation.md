# ``SwiftOSC``

Open Sound Control (OSC) toolkit written in Swift for Apple platforms, Linux, and Android.

## Overview

![SwiftOSC](swift-osc-banner.png)

- OSC address pattern matching and dispatch
- Convenient OSC message value type masking, validation and strong-typing
- Modular: use one of the provided network I/O extensions, or use your own
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

Or to import SwiftOSC without networking I/O in order to implement your own sockets:

```swift
import SwiftOSCCore
```

> Tip:
>
> You may use any of the alternative network I/O extensions available instead of the default by using any of them as a dependency directly.
> See the [`SwiftOSC` README file](https://github.com/orchetect/swift-osc) for links to all available extensions. 

### Value Types

- See [OSC Value Types](https://swiftpackageindex.com/orchetect/swift-osc-core/main/documentation/swiftosccore/osc-value-types) in SwiftOSCCore documentation

### Sending and Receiving

- See the [Getting Started guide](https://swiftpackageindex.com/orchetect/swift-osc-io-cocoa/main/documentation/swiftosciococoa/getting-started) in the default network I/O extension repository.

### Example Code

- See the [Examples](https://github.com/orchetect/swift-osc-io-cocoa/tree/main/Examples) folder in the default network I/O extension repository.

> Tip:
>
> Each network I/O extension repository contains their own example projects to quickly get started.
> See the [`SwiftOSC` README file](https://github.com/orchetect/swift-osc) for links to all available extensions.
