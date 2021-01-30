# OSCKit

<p>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/Swift%205.3-compatible-orange.svg?style=flat"
	 alt="Swift 5.3 compatible" /></a>
<a href="#installation">
<img src="https://img.shields.io/badge/SPM-compatible-orange.svg?style=flat"
	 alt="Swift Package Manager (SPM) compatible" /></a>
<a href="https://developer.apple.com/swift">
<img src="https://img.shields.io/badge/platform-macOS%2010.12%20|%20iOS%2010%20|%20tvOS%2010%20|%20watchOS%203-green.svg?style=flat"
	 alt="Platform - macOS 10.12 | iOS 10 | tvOS 10 | watchOS 3" /></a>
<a href="#contributions">
<img src="https://img.shields.io/badge/Linux-not%20tested-black.svg?style=flat"
	 alt="Linux - not tested" /></a>
<a href="https://github.com/orchetect/OSCKit/blob/main/LICENSE">
<img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat"
	 alt="License: MIT" /></a>

Open Sound Control (OSC) library written in Swift.

**Note:** The library does not contain a networking layer so you can modularly integrate OSCKit into whatever network module you choose.

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

func handleOSCPayload(_ oscPayload: OSCBundlePayload) {
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

- [ ] Add full timetag support
- [ ] Add OSC 1.0 spec address parsing
- [ ] Add example projects with network layers (ie: Apple's `Network.framework`)
- [ ] Cross-platform testing

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/OSCKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
