![OSCKit](Images/osckit-banner.png)

# OSCKit

[![CI Build Status](https://github.com/orchetect/OSCKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/OSCKit/actions/workflows/build.yml) [![Platforms - macOS | iOS | tvOS | watchOS](https://img.shields.io/badge/platforms-macOS%2010.12%2B%20|%20iOS%2010%2B%20|%20tvOS%2010%2B%20|%20watchOS%203%2B%20-lightgrey.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/OSCKit/blob/main/LICENSE)

Open Sound Control library written in Swift.

**Note:** The library does not contain a networking layer. This is by design so that OSCKit can be integrated into your network module of choice. This repo contains an example project demonstrating using it with Apple's `Network.framework`.

Unit tests implemented.

## Installation

### Swift Package Manager (SPM)

To add OSCKit to your Xcode project:

1. Select File → Swift Packages → Add Package Dependency
2. Add package using  `https://github.com/orchetect/OSCKit` as the URL.

## Getting Started

### Setup

```swift
import OSCKit

// set up your UDP port(s) with a 3rd-party network library of choice;
// no network layer is included in OSCKit
```

### Receive

```swift
// in your UDP socket receive handler,
// assuming the "data" variable is raw data bytes from a received UDP packet:

do {
  guard let oscPayload = try data.parseOSC() else { return }
  handleOSCPayload(oscPayload)
} catch let error as OSCBundle.DecodeError {
  // handle bundle errors
} catch let error as OSCMessage.DecodeError {
  // handle message errors
} catch {
  // handle other errors
}

func handleOSCPayload(_ oscPayload: OSCPayload) {
  switch oscPayload {
  case .bundle(let bundle):
    // recursively handle nested bundles and messages
    bundle.elements.forEach { handleOSCPayload($0) }
  case .message(let message):
    // handle message
  }
}
```

### Send

#### Bundle

To send multiple OSC messages or nested OSC bundles to the same destination at the same time, pack them in an `OSCBundle` and send the bundle's `rawData` bytes as the outgoing UDP message.

```swift
let msg1 = OSCMessage(address: "/msg1")
let msg2 = OSCMessage(address: "/msg2", values: [.string("string"), .int32(123)])

let bundle = OSCBundle([msg1, msg2])

yourUDPSocket.send(bundle.rawData)
```

#### Message

To send a single message, construct an `OSCMessage` and send the message's `rawData` bytes as the outgoing UDP message.

```swift
let msg = OSCMessage(address: "/msg2", values: [.string("string"), .int32(123)])

yourUDPSocket.send(msg.rawData)
```

## Documentation

Will be added in future.

## Roadmap

- [ ] Add full timetag support (OSC 1.0 spec)
- [ ] Add address parsing (OSC 1.0 spec)
- [ ] Cross-platform testing
- [ ] Add custom OSC type tag values (♻️ In Progress)

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/OSCKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
