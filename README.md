![OSCKit](Images/osckit-banner.png)

# OSCKit

[![CI Build Status](https://github.com/orchetect/OSCKit/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/OSCKit/actions/workflows/build.yml) ![Platforms - macOS 10.13+ | iOS 11+ | tvOS 11+](https://img.shields.io/badge/platforms-macOS%2010.13+%20|%20iOS%2011+%20|%20tvOS%2011+%20-lightgrey.svg?style=flat) [![Swift 5.7+](https://img.shields.io/badge/Swift-5.7+-orange.svg?style=flat)](https://developer.apple.com/swift) [![Xcode 14+](https://img.shields.io/badge/Xcode-14+-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/OSCKit/blob/main/LICENSE)

Open Sound Control library written in Swift.

Fully unit tested.

Note that  Swift 5.7+ and Xcode 14+ are minimum requirements.

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

A single global OSC client can be created once at app startup then you can access it from aynwhere to send OSC messages to any receiver.

```swift
let oscClient = OSCClient()
```

### OSC Messages

To send a single message, construct an `OSCMessage` and send it using a global `OSCClient` instance.

```swift
let msg = OSCMessage(address: "/msg2",
                     values: [.string("string"), .int32(123)])

oscClient.send(msg, to: "192.168.1.2", port: 8000)
```

### OSC Bundles

To send multiple OSC messages or nested OSC bundles to the same destination at the same time, pack them in an `OSCBundle` and send it using a global `OSCClient` instance.

```swift
let msg1 = OSCMessage(address: "/msg1")
let msg2 = OSCMessage(address: "/msg2", 
                      values: [.string("string"), .int32(123)])
let bundle = OSCBundle([msg1, msg2])

oscClient.send(bundle, to: "192.168.1.2", port: 8000)
```

#### Sending with a Future Time Tag

OSC bundles carry a time tag. By default if not specified, this is set to a value equivalent to "immediate" which receivers will interpret and handle the bundle and the message(s) it contains immediately upon receiving them.

It is possible to specify a future time tag. When present, a receiver holds the bundle in memory and handles it at the future time specified in the time tag.

```swift
// by default, bundles use an immediate time tag; so these two lines are identical:
OSCBundle([msg1, msg2])
OSCBundle([msg1, msg2], timeTag: .immediate())

// specify a non-immediate time tag of the current time
OSCBundle([msg1, msg2], timeTag: .now())

// 5 seconds in the future
OSCBundle([msg1, msg2], timeTag: .timeIntervalSinceNow(5.0))

// at the specified time as a Date instance
let date = Date( ... )
OSCBundle([msg1, msg2], timeTag: .future(date))

// a raw time tag can also be supplied
let timeTag: UInt64 = 16535555370123264000
OSCBundle([msg1, msg2], timeTag: .init(timeTag))
```

## Receiving OSC

### Create OSC Server

Create the server instance. A single global instance can be created one at app startup to receive OSC messages on a specific port. The default OSC port is 8000 but it may be set to any open port if desired.

```swift
let oscServer = OSCServer(port: 8000)
```

Set the receiver handler.

```swift
oscServer.setHandler { [weak self] oscMessage in
    // Important: handle received OSC on main thread if it may result in UI updates
    DispatchQueue.main.async {
        do {
            try self?.handle(received: oscMessage)
        } catch {
            print(error)
        }
    }
}

private func handle(received oscMessage: OSCMessage) throws {
  // handle received messages here
}
```

Then start the server to being listening for inbound OSC packets.

```swift
class AppDelegate: NSObject, NSApplicationDelegate {
    try oscServer.start()
}
```

If received OSC bundles contain a future time tag, these bundles will be held in memory by the `OSCServer` automatically and scheduled to be dispatched to the handler at the future time.

### Address Parsing

#### Option 1: Imperative address pattern matching

```swift
// example receied OSC message with address "/{some,other}/address/*"
private func handle(received oscMessage: OSCMessage) throws {
    if oscMessage.address.pattern(matches: "/some/address/methodA") { // will match
        // perform methodA action using oscMessage.values
    }
    if oscMessage.address.pattern(matches: "/some/address/methodB") { // will match
        // perform methodB action using oscMessage.values
    }
    if oscMessage.address.pattern(matches: "/different/methodC") { // won't match
        // perform methodC action using oscMessage.values
    }
}
```

#### Option 2: Using `OSCDispatcher` for automated address pattern matching

OSCKit provides an optional abstraction called `OSCDispatcher`.

Local OSC addresses (methods) are registered with the dispatcher and it proves a unique ID token representing it. When an OSC message is received, pass its address to the dispatcher and it will pattern match it against all registered local addresses and return an array of local method IDs that match.

Consider that an inbound message address pattern of `/some/address/*` will match both `/some/address/methodB` and `/some/address/methodC` below:

```swift
class OSCReceiver {
  private let oscDispatcher = OSCDispatcher()
  
  private let idMethodA: OSCDispatcher.MethodID
  private let idMethodB: OSCDispatcher.MethodID
  private let idMethodC: OSCDispatcher.MethodID
  
  public init() {
    // register local OSC methods and store the ID tokens once before receiving OSC messages
    idMethodA = oscDispatcher.register(address: "/methodA")
    idMethodB = oscDispatcher.register(address: "/some/address/methodB")
    idMethodC = oscDispatcher.register(address: "/some/address/methodC")
  }
  
  // when received OSC messages arrive, pass them to the dispatcher
  public func handle(oscMessage: OSCMessage) throws {
    let ids = oscDispatcher.methods(matching: oscMessage.address)
    
    guard !ids.isEmpty else {
      print("Received unrecognized OSC message:", oscMessage)
      return
    }
    
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
          print("Received unhandled OSC message:", oscMessage)
      }
    }
  }
  
  private func performMethodA(_ str: String) { }
  private func performMethodB(_ str: String, _ int: Int) { }
  private func performMethodC(_ str: String, _ dbl: Double?) { }
}
```

### Parsing OSC Message Values

When a specific number of values and value types are expected:

#### Option 1: Use `masked()` to validate and unwrap expected value types

Validate and unwrap value array with expected member `String`:

```swift
let value = try oscMessage.values.masked(String.self)
print("string: \(value)")
```

Validate and unwrap value array with expected members `String, Int32?`:

```swift
let values = try oscMessage.values.masked(String.self, Int32?.self)
print("string:", values.0, 
      "int32:", values.1)
```

#### Option 2: Manually unwrap expected value types

Validate and unwrap value array with expected member `String`:

```swift
guard oscMessage.values.count == 1,
      case let .string(value) = oscMessage.values[0] else { return }
print("string: \(value)")
```

Validate and unwrap value array with expected members `String, Int32?`:

```swift
guard (1...2).contains(oscMessage.values.count),
      case let .string(val0) = oscMessage.values[0] else { return }
let val1: Int32? = {
  if case let .int32(val1) = oscMessage.values[1] { return val1 } else { return nil }
}()
print("string:", val0, 
      "int32:", val1)
```

#### Option 3: Parse a variable number of values

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

## OSC Value Types

The following OSC value types are available, conforming to the [Open Sound Control 1.0 specification](http://opensoundcontrol.org/spec-1_0.html).

```swift
// core types
.int32(Int32)
.float32(Float32)
.string(ASCIIString)
.blob(Data)

// extended types
.int64(Int64)
.timeTag(OSCTimeTag)
.double(Double)
.stringAlt(ASCIIString)
.character(ASCIICharacter)
.midi(MIDIMessage)
.bool(Bool)
.null
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
