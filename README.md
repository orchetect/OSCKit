![OSCKit](Images/osckit-banner.png)

# OSCKit

[![CI Build Status](https://github.com/orchetect/OSCKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/OSCKit/actions/workflows/build.yml) ![Platforms - macOS 10.13+ | iOS 11+ | tvOS 11+](https://img.shields.io/badge/platforms-macOS%2010.13+%20|%20iOS%2011+%20|%20tvOS%2011+%20-lightgrey.svg?style=flat) [![Swift 5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift) [![Xcode 14](https://img.shields.io/badge/Xcode-14-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/OSCKit/blob/main/LICENSE)

Open Sound Control ([OSC](https://opensoundcontrol.stanford.edu)) library for macOS, iOS and tvOS written in Swift.

- OSC address pattern matching and dispatch
- Convenient OSC message value type masking, validation and strong-typing
- Modular: use the provided UDP network layer by default, or use your own
- Support for custom OSC types
- Thread-safe
- Fully unit tested
- Thorough documentation

## Getting Started

The library is available as a Swift Package Manager (SPM) package.

Use the URL `https://github.com/orchetect/OSCKit` when adding the library to a project or Swift package.

See the [getting started guide](https://orchetect.github.io/OSCKit/documentation/osckit/getting-started) for a detailed walkthrough of how to get the most out of MIDIKit.

The [Examples](Examples) folder also contains projects to quickly get started.

## Documentation

See the [online documentation](https://orchetect.github.io/OSCKit/) or view it in Xcode's documentation browser by selecting the **Product → Build Documentation** menu.

This includes a getting started guide, links to examples, and troubleshooting tips.

## Dependencies

- [CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket) is used by the `OSCKit` target for network sockets.
- [SwiftASCII](https://github.com/orchetect/SwiftASCII) is used for ASCII string and character formatting and validation.

## Documentation

Refer to this README for an overview of library features and syntax, and check out the [example projects](Examples).

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](LICENSE) for details.

## Sponsoring

If you enjoy using OSCKit and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/OSCKIt/discussions) first prior to new submitting PRs for features or modifications is encouraged.
