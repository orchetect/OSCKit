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
func handleUDP(receivedPacket data: Data) {
  do {
    guard let oscPayload = try data.parseOSC() else { return }
    try handle(oscPayload: oscPayload)
  } catch let error as OSCBundle.DecodeError {
    // handle bundle errors
  } catch let error as OSCMessage.DecodeError {
    // handle message errors
  } catch {
    // handle other errors
  }
}

func handle(oscPayload: OSCPayload) throws {
  switch oscPayload {
  case .bundle(let oscBundle):
    // recursively handle nested bundles and messages
    try oscBundle.elements.forEach { try handle(oscPayload: $0) }
    
  case .message(let oscMessage):
    // handle message
    try handle(oscMessage: OSCMessage)
  }
}
```

### Address Matching

#### Individual address matching without pattern matching

```swift
let receivedAddress = OSCAddress("/some/address/here")
let localAddress = OSCAddress("/some/address/here")
let isMatch = receivedAddress == localAddress // true, verbatim string comparison only
```

#### Individual address pattern matching

```swift
let receivedAddress = OSCAddress("/{some,other}/address/*")
let localAddress = OSCAddress("/some/address/here")
let isMatch = receivedAddress.pattern(matches: localAddress) // true
```

#### Using `Dispatcher` for automated pattern matching

OSCKit provides an optional abstraction called `OSCAddress.Dispatcher`.

Local OSC addresses (methods) are registered with the dispatcher and it proves a unique ID token representing it. When an OSC message is received, pass its address to the dispatcher and it will pattern match it against all registered local addresses and return an array of local method IDs that match.

Consider that an inbound message address pattern of `/some/address/*` will match both `/some/address/methodB` and `/some/address/methodC` below:

```swift
class OSCReceiver {
  // register local OSC methods and store the ID tokens once before receiving OSC messages
  private let oscDispatcher = OSCAddress.Dispatcher()
  private lazy var idMethodA = oscDispatcher.register(address: "/methodA")
  private lazy var idMethodB = oscDispatcher.register(address: "/some/address/methodB")
  private lazy var idMethodC = oscDispatcher.register(address: "/some/address/methodC")
  
  // when received OSC messages arrive, pass them to the dispatcher
  public func handle(oscMessage: OSCMessage) throws {
    let ids = oscDispatcher.methods(matching: oscMessage.address)
    
    try ids.forEach { id in
      switch id {
        case idMethodA:
          let value = try oscMessage.values.masked(String.self)
          performMethodA(value)
          
        case idMethodB:
          let values = try oscMessage.values.masked(String.self, Int.self)
          performMethodB(values.0, values.1)
          
        case idMethodC:
          let values = try oscMessage.values.masked(String.self, Double?.self)
          performMethodC(values.0, values.1)
          
        default:
          break
      }
    }
  }
  
  private func performMethodA(_ str: String) { }
  private func performMethodB(_ str: String, _ int: Int) { }
  private func performMethodC(_ str: String, _ int: Double?) { }
}
```

### Parsing OSC Message Values

When a specific number of values and value types are expected:

#### Use `masked()` to validate and unwrap expected value types

```swift
// validate and unwrap value array with expected types: [String]
let value = try oscMessage.values.masked(String.self)
print("/test/method1 with string:", value)
```

```swift
// validate and unwrap value array with expected types: [String, Int32?]
let values = try oscMessage.values.masked(String.self, Int32?.self)
print("/test/method2 with string: \(values.0), int32: \(values.1 ?? 0)")
```

#### Manually unwrap expected value types

```swift
// validate and unwrap value array with expected types: [String]
guard oscMessage.values.count == 1,
      case let .string(value) = oscMessage.values[0] else { return }
print("/test/method1 with string:", value)
```

```swift
// validate and unwrap value array with expected types: [String, Int32?]
guard (1...2).contains(oscMessage.values.count),
      case let .string(val0) = oscMessage.values[0] else { return }
let val1: Int32? = {
  if case let .int32(val1) = oscMessage.values[1] { return val1 } else { return nil }
}()
print("/test/method2 with string: \(val0), int32: \(val1 ?? 0)")
```

#### Parse a variable number of values

```swift
oscMessage.values.forEach { oscValue
  switch oscValue {
    case let .string(val):
      print(val)
    case let .int32(val):
      print(val)
      
    // ... additional cases for other value types ...
  }
}
```

### OSC Value Types

The following OSC value types are available, conforming to the [Open Sound Control 1.0 specification](http://opensoundcontrol.org/spec-1_0.html).

```swift
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
```

### Send

#### OSC Message

To send a single message, construct an `OSCMessage` and send the message's `rawData` bytes as the outgoing UDP message.

```swift
let msg = OSCMessage(address: "/msg2", 
                     values: [.string("string"), .int32(123)])

yourUDPSocket.send(msg.rawData)
```

#### OSC Bundle

To send multiple OSC messages or nested OSC bundles to the same destination at the same time, pack them in an `OSCBundle` and send the bundle's `rawData` bytes as the outgoing UDP message.

```swift
let msg1 = OSCMessage(address: "/msg1")
let msg2 = OSCMessage(address: "/msg2", 
                      values: [.string("string"), .int32(123)])
let bundle = OSCBundle([msg1, msg2])

yourUDPSocket.send(bundle.rawData)
```

## Documentation

Will be added in future. In the meantime, refer to this README's [Getting Started](#getting-started) section, and check out the [Example projects](Examples).

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
