![OSCKit](Images/osckit-banner.png)

# OSCKit

[![CI Build Status](https://github.com/orchetect/OSCKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/OSCKit/actions/workflows/build.yml) [![Platforms - macOS | iOS | tvOS | watchOS](https://img.shields.io/badge/platforms-macOS%2010.12%2B%20|%20iOS%2010%2B%20|%20tvOS%2010%2B%20|%20watchOS%203%2B%20-lightgrey.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/OSCKit/blob/main/LICENSE)

Open Sound Control library written in Swift.

Full unit test coverage.

## Getting Started

### Swift Package Manager (SPM)

1. Add OSCKit as a dependency using Swift Package Manager.
   - In an app project or framework, in Xcode:
     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/orchetect/OSCKit`
   
   - In a Swift Package, add it to the Package.swift dependencies:
     ```swift
     .package(url: "https://github.com/orchetect/OSCKit", from: "0.2.2")
     ```

2. Import the library:
   ```swift
   import OSCKit
   ```

3. Set up UDP port(s) using your networking library of choice. To keep OSCKit lightweight and flexible, no network layer is included in OSCKit. The Examples folder contains some examples using 3rd-party network libraries to get you started.
   
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
  case .bundle(let oscBundle):
    // recursively handle nested bundles and messages
    oscBundle.elements.forEach { handleOSCPayload($0) }
  case .message(let oscMessage):
    // handle message
  }
}
```

### Parsing OSC Message Values

When a specific number of values and value types are expected:

```swift
// first test that the value count is expected, then unwrap each value
guard oscMessage.values.count == 2,
      case let .string(val1) = oscMessage.values[0],
      case let .int32(val2) = oscMessage.values[1]
else { return }

print("Address:", oscMessage.address, 
      "Values:", val1, val2)
```

To parse a variable number of values:

```swift
// iterate through all values and use a switch case to determine the value type

oscMessage.values.forEach { oscValue
  switch oscValue {
    case let .string(val):
      print(val)
    case let .int32(val):
      print(val)
      
    // ... add any other value types you want to handle ...
  }
}
```

### OSC Value Types

The following OSC value types are available, conforming to the [Open Sound Control 1.0 specification](http://opensoundcontrol.org/spec-1_0.html).

```swift
enum OSCMessageValue {
  // core types
  .int32(Int32)
  .float32(Float32)
  .string(ASCIIString)
  .blob(Data)
  
  // extended types
  .int64(Int64)
  .timeTag(Int64)
  .double(Double)
  .stringAlt(ASCIIString)
  .character(ASCIICharacter)
  .midi(MIDIMessage)
  .bool(Bool)
  .null
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

Will be added in future. In the meantime, refer to this README file for a getting started guide, and check out the [Example projects](Examples).

## Roadmap

- [ ] Add full timetag support (OSC 1.0 spec)
- [ ] Add address parsing (OSC 1.0 spec)
- [ ] Add custom OSC type tag values

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/OSCKit/blob/master/LICENSE) for details.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
