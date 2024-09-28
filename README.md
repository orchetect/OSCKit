![OSCKit](Images/osckit-banner.png)

# OSCKit

[![CI Build Status](https://github.com/orchetect/OSCKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/OSCKit/actions/workflows/build.yml) ![Platforms - macOS 10.13+ | iOS 11+ | tvOS 11+ | visionOS 1+](https://img.shields.io/badge/platforms-macOS%2010.13+%20|%20iOS%2011+%20|%20tvOS%2011+%20|%20visionOS%201+-lightgrey.svg?style=flat) [![Swift 5.7+](https://img.shields.io/badge/Swift-5.7+-orange.svg?style=flat)](https://developer.apple.com/swift) [![Xcode 16+](https://img.shields.io/badge/Xcode-16+-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/OSCKit/blob/main/LICENSE)

Open Sound Control ([OSC](https://opensoundcontrol.stanford.edu)) library for macOS, iOS and tvOS written in Swift.

- OSC address pattern matching and dispatch
- Convenient OSC message value type masking, validation and strong-typing
- Modular: use the provided UDP network layer by default, or use your own
- Support for custom OSC types
- Supports Swift Concurrency
- Fully unit tested
- Full DocC documentation

## Getting Started

The library is available as a Swift Package Manager (SPM) package.

Use the URL `https://github.com/orchetect/OSCKit` when adding the library to a project or Swift package.

See the [getting started guide](https://orchetect.github.io/OSCKit/documentation/osckit/getting-started) for a detailed walkthrough of how to get the most out of OSCKit.

The [Examples](Examples) folder also contains projects to quickly get started.

## Documentation

See the [online documentation](https://orchetect.github.io/OSCKit/) or view it in Xcode's documentation browser by selecting the **Product → Build Documentation** menu.

This includes a getting started guide, links to examples, and troubleshooting tips.

## Dependencies

- [CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket) is used by the `OSCKit` target for network sockets.
- [SwiftASCII](https://github.com/orchetect/SwiftASCII) is used for ASCII string and character formatting and validation.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](LICENSE) for details.

## Sponsoring

If you enjoy using OSCKit and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for questions and feature ideas:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/OSCKit/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/OSCKit/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/OSCKIt/discussions) first prior to new submitting PRs for features or modifications is encouraged.
