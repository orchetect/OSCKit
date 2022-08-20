![OSCKit](Images/osckit-banner.png)

# OSCKit

[![CI Build Status](https://github.com/orchetect/OSCKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/OSCKit/actions/workflows/build.yml) ![Platforms - macOS 10.13+ | iOS 11+ | tvOS 11+](https://img.shields.io/badge/platforms-macOS%2010.13+%20|%20iOS%2011+%20|%20tvOS%2011+%20-lightgrey.svg?style=flat) [![Swift 5.7+](https://img.shields.io/badge/Swift-5.7+-orange.svg?style=flat)](https://developer.apple.com/swift) [![Xcode 14+](https://img.shields.io/badge/Xcode-14+-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/OSCKit/blob/main/LICENSE)

Open Sound Control library for macOS, iOS and tvOS written in Swift.

- OSC address pattern matching and dispatch
- Convenient OSC message value type masking, validation and strong-typing
- Modular: use the provided UDP network layer by default, or use your own
- Support for custom OSC types
- Thread-safe
- Fully unit tested

>  **Note**: Swift 5.7+ and Xcode 14+ are minimum requirements. OSCKit [0.3.1](https://github.com/orchetect/OSCKit/releases/tag/0.3.1) can be used with Xcode 13.

## Getting Started

### Swift Package Manager (SPM)

1. Add OSCKit as a dependency using Swift Package Manager.
   - In an app project or framework, in Xcode:
     - Select the menu: **File → Swift Packages → Add Package Dependency...**
     - Enter this URL: `https://github.com/orchetect/OSCKit`

   - In a Swift Package, add it to the Package.swift dependencies:
     ```swift
     .package(url: "https://github.com/orchetect/OSCKit", from: "0.4.0")
     ```

2. Import the library:
   ```swift
   import OSCKit
   ```
   
   Or to import OSCKit without networking I/O in order to implement your own UDP sockets:
   
   ```swift
   import OSCKitCore
   ```
   
3. The [Examples](Examples) folder contains projects to get started.

## Sending OSC

### Create OSC Client

A single global OSC client is all that is needed to send OSC packets. It can be used to send OSC messages to any receiver.

```swift
let oscClient = OSCClient()
```

### OSC Messages

To send a single message, construct an `OSCMessage` and send it using a global `OSCClient` instance.

```swift
let msg = OSCMessage("/msg2", values: ["string", 123])

oscClient.send(msg, to: "192.168.1.2", port: 8000)
```

### OSC Bundles

To send multiple OSC messages or nested OSC bundles to the same destination at the same time, pack them in an `OSCBundle` and send it using a global `OSCClient` instance.

```swift
// Option 1: build elements separately
let msg1 = OSCMessage("/msg1")
let msg2 = OSCMessage("/msg2",  values: ["string", 123])
let bundle = OSCBundle([msg1, msg2])

// Option 2: build elements inline
let bundle = OSCBundle([
    .message("/msg1"),
    .message("/msg2",  values: ["string", 123])
])

// send the bundle
oscClient.send(bundle, to: "192.168.1.2", port: 8000)
```

#### Sending with a Future Time Tag

OSC bundles carry a time tag. If not specified, by default a time tag equivalent to "immediate" is used, which indicates to receivers that they should handle the bundle and the message(s) it contains immediately upon receiving them.

It is possible to specify a future time tag. When present, a receiver which adheres to the OSC 1.0 spec will hold the bundle in memory and handle it at the future time specified in the time tag.

```swift
// by default, bundles use an immediate time tag; these two lines are identical:
OSCBundle([ ... ])
OSCBundle(timeTag: .immediate(), [ ... ])

// specify a non-immediate time tag of the current time
OSCBundle(timeTag: .now(), [ ... ])

// 5 seconds in the future
OSCBundle(timeTag: .timeIntervalSinceNow(5.0), [ ... ])

// at the specified time as a Date instance
let date = Date( ... )
OSCBundle(timeTag: .future(date), [ ... ])

// a raw time tag can also be supplied
let timeTag: UInt64 = 16535555370123264000
OSCBundle(timeTag: .init(timeTag), [ ... ])
```

## Receiving OSC

### Create OSC Server

Create a server instance. A single global instance is often created once at app startup to receive OSC messages on a specific port. The default OSC port is 8000 but it may be set to any open port if desired.

```swift
let oscServer = OSCServer(port: 8000)
```

Set the receiver handler.

```swift
oscServer.setHandler { [weak self] oscMessage, timeTag in
    // Note: handler is called on the main thread
    // and is thread-safe if it causes UI updates
    do {
        try self?.handle(received: oscMessage)
    } catch {
        print(error)
    }
}

private func handle(received oscMessage: OSCMessage) throws {
  // handle received messages here
}
```

Then start the server to begin listening for inbound OSC packets.

```swift
// call this once, usually during your app's startup
try oscServer.start()
```

If received OSC bundles contain a future time tag and the `OSCServer` is set to `.osc1_0` mode, these bundles will be held in memory automatically and scheduled to be dispatched to the handler at the future time.

Note that as per the OSC 1.1 proposal, this behavior has largely been deprecated. `OSCServer` will default to `.ignore` and not perform any scheduling unless explicitly set to `.osc1_0` mode.

### Address Parsing

#### Option 1: Imperative address pattern matching

```swift
// example: received OSC message with address "/{some,other}/address/*"
private func handle(received message: OSCMessage) throws {
    if message.addressPattern.matches(localAddress: "/some/address/methodA") { // will match
        // perform methodA action using message.values
    }
    if message.addressPattern.matches(localAddress: "/some/address/methodB") { // will match
        // perform methodB action using message.values
    }
    if message.addressPattern.matches(localAddress: "/different/methodC") { // won't match
        // perform methodC action using message.values
    }
}
```

#### Option 2: Using `OSCAddressSpace` for automated address pattern matching

OSCKit provides an abstraction called `OSCAddressSpace`.

This object is generally instanced once and stored globally.

Each local OSC address (OSC Method) must be registered once with this object. It will return a unique ID token to correspond to each method that is registered. When an OSC message is received, you then pass its address pattern to the `methods(matching:)` method of the `OSCAddressSpace` instance. This method will pattern-match it against all registered local addresses and return an array of local method IDs that match.

Consider that an inbound message address pattern of `/some/address/*` will match both `/some/address/methodB` and `/some/address/methodC` below:

```swift
class OSCReceiver {
  private let addressSpace = OSCAddressSpace()
  
  private let idMethodA: OSCAddressSpace.MethodID
  private let idMethodB: OSCAddressSpace.MethodID
  private let idMethodC: OSCAddressSpace.MethodID
  
  public init() {
    // register local OSC methods and store the ID tokens once before receiving OSC messages
    idMethodA = addressSpace.register(localAddress: "/methodA")
    idMethodB = addressSpace.register(localAddress: "/some/address/methodB")
    idMethodC = addressSpace.register(localAddress: "/some/address/methodC")
  }
  
  // when received OSC messages arrive, pass them to the dispatcher
  public func handle(message: OSCMessage) throws {
    let ids = addressSpace.methods(matching: message.addressPattern)
    
    guard !ids.isEmpty else {
      print("Received unrecognized OSC message:", message)
      return
    }
    
    try ids.forEach { id in
      switch id {
        case idMethodA:
          let str = try message.values.masked(String.self)
          performMethodA(str)
          
        case idMethodB:
          let (str, int) = try message.values.masked(String.self, Int?.self)
          performMethodB(str, int)
          
        case idMethodC:
          let (str, num) = try message.values.masked(String.self, AnyOSCNumberValue.self)
          performMethodC(str, num.doubleValue)
          
        default:
          print("Received unhandled OSC message:", message)
      }
    }
  }
  
  private func performMethodA(_ str: String) { }
  private func performMethodB(_ str: String, _ int: Int?) { }
  private func performMethodC(_ str: String, _ dbl: Double) { }
}
```

### Parsing OSC Message Values

#### Option 1: Use `masked()` to validate and unwrap expected value types

Since local OSC "addresses" (OSC Methods) are generally considered methods (akin to functions) which take parameters (OSC values/arguments), in most use cases an OSC Method will have a defined type mask. OSCKit provides a powerful and flexible API to both validate and strongly type an OSC value array.

Validate and unwrap value array with expected member `String`:

```swift
let str = try oscMessage.values.masked(String.self)
print("string: \(str)")
```

The special wrapper type `AnyOSCNumberValue` is able to match any number and provides easy type-erased access to its contents, converting value types if necessary automatically.

Validate and unwrap value array with expected members `String, Int, <number>?`:

```swift
let (str, int, num) = try oscMessage.values.masked(String.self, 
                                                   Int.self,
                                                   AnyOSCNumberValue?.self)
print(str, int, num.intValue)
print(str, int, num.doubleValue)
print(str, int, num.base) // access to the strongly typed integer or floating-point value
```

#### Option 2: Manually unwrap expected value types

It is generally easier to use `masked()` as demonstrated above, since it handles masking, strongly typing, as well as translation of interpolated (`Int8`, `Int16`, etc.) and opaque (`AnyOSCNumberValue`, etc.) types.

Validate and unwrap value array with expected member `String`:

```swift
guard oscMessage.values.count == 1 else { ... }
guard let str = oscMessage.values[0] as? String else { ... } // compulsory
print(str) // String
```

Validate and unwrap value array with expected members `String, Int32?, Double?`:

```swift
guard (1...3).contains(oscMessage.values.count) else { ... }
guard let str = oscMessage.values[0] as? String else { ... } // compulsory
let int: Int32? = oscMessage.count > 1 ? oscMessage.values[1] as? Int32 : nil // optional
let dbl: Double? = oscMessage.count > 2 ? oscMessage.values[2] as? Double : nil // optional
print(str, int, dbl) // String, Int32?, Double?
```

#### Option 3: Parse a variable number of values

It may be desired to imperatively validate and cast values when their expected mask may be unknown.

```swift
oscMessage.values.forEach { oscValue
  switch oscValue {
    case let val as String:
      print(val)
    case let val as Int32:
      print(val)
    default:
      // unhandled
  }
}
```

## OSC Value Types

The following OSC value types are available, conforming to the [Open Sound Control 1.0 specification](http://opensoundcontrol.org/spec-1_0.html).

| Core OSC Type           | Swift Concrete Type | Standard Invocation | Convenience Invocation |
| ----------------------- | ------------------- | ------------------- | ---------------------- |
| int32, big-endian       | `Int32`             | `Int32( ... )`      | -                      |
| float32, big-endian     | `Float32`           | `Float32( ... )`    | -                      |
| string, null-terminated | `String`            | `String( ... )`     | `String` literal       |
| blob, null-terminated   | `Data`              | `Data( ... )`       | -                      |

| Extended OSC Type         | Swift Concrete Type | Standard Invocation           | Convenience Invocation |
| ------------------------- | ------------------- | ----------------------------- | ---------------------- |
| bool                      | `Bool`              | `true`, `false`               | -                      |
| int64, big-endian         | `Int64`             | `Int64( ... )`                | -                      |
| double, big-endian        | `Double`            | `Double( ... )`               | -                      |
| ASCII char                | `Character`         | `Character( ... )`            | `Character` literal    |
| `[` ... `]`               | `OSCArrayValue`     | `OSCArrayValue([ ... ])`      | `.array([ ... ])`      |
| uint64, big-endian        | `OSCTimeTag`        | `OSCTimeTag(1)`               | `.timeTag(1)`          |
| string, null-terminated   | `OSCStringAltValue` | `OSCStringAltValue("String")` | `.stringAlt("String")` |
| 4-byte MIDI channel voice | `OSCMIDIValue`      | `OSCMIDIValue( ... )`         | `.midi( ... )`         |
| impulse/infinitum/bang    | `OSCImpulseValue`   | `OSCImpulseValue()`           | `.impulse`             |
| null                      | `OSCNullValue`      | `OSCNullValue()`              | `.null`                |

OSCKit adds the following interpolated types:

```swift
Int       // transparently encodes as Int32 core type, converting any BinaryInteger
Int8      // transparently encodes as Int32 core type
Int16     // transparently encodes as Int32 core type
UInt      // transparently encodes as Int64 core type
UInt8     // transparently encodes as Int32 core type
UInt16    // transparently encodes as Int32 core type
UInt32    // transparently encodes as Int64 core type
Float16   // transparently encodes as Float32 core type
Float80   // transparently encodes as Double extended type
Substring // transparently encodes as String core type
```

OSCKit also adds the following opaque type-erasure types:

```swift
AnyOSCNumberValue // wraps any BinaryInteger or BinaryFloatingPoint
```

## Documentation

Will be added in future. In the meantime, refer to this README's [Getting Started](#getting-started) section, and check out the [Example projects](Examples).

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/OSCKit/blob/master/LICENSE) for details.

## Sponsoring

If you enjoy using OSCKit and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Contributions

Contributions are welcome. Feel free to post an Issue to discuss.
