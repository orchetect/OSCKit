# OSC Address Pattern Parsing

Methods for parsing OSC Message address patterns.

@Comment {
    // -------------------------------------------------------------------
    // NOTE: This file is duplicated in both OSCKit and OSCKitCore targets.
    //         Ensure both files are updated when making changes.
    // -------------------------------------------------------------------
}

## Overview

There are a few approaches to parsing OSC message address patterns, depending on your needs.

## Background

An OSC Method is defined as being the last path component in the address. OSC Methods are the
potential destinations of OSC messages received by the OSC server and correspond to each of the
points of control that the application makes available.

The `methodname` path component is the method name in the following address examples:
  ```
  /methodname
  /container1/container2/methodname
  ```

Any other path components besides the last are referred to as _containers_.

A container may also be a method. Simply register it the same way as other methods.

### Imperative address pattern matching

Simple matching can be performed using the ``OSCAddressPattern/matches(localAddress:)`` method directly on the message's ``OSCMessage/addressPattern`` property.

```swift
// example: received OSC message with address "/{some,other}/address/*"
private func handle(received message: OSCMessage) throws {
    let pattern = message.addressPattern
    if pattern.matches(localAddress: "/some/address/methodA") { 
        // (will match in this example)
        // ... perform methodA action using message.values ...
    }
    if pattern.matches(localAddress: "/some/address/methodB") {
        // (will match in this example)
        // ... perform methodB action using message.values ...
    }
    if pattern.matches(localAddress: "/different/methodC") {
        // (won't match in this example)
        // ... perform methodC action using message.values ...
    }
}
```

### Using OSCAddressSpace for automated address pattern matching

OSCKit provides an abstraction called ``OSCAddressSpace``. This object is generally instanced once and stored globally.

Each local OSC address (OSC Method) is registered once with this object in order to enable it to perform matching against received OSC message address patterns. Each method is assigned an ID, and can optionally store a closure.

Method IDs, method closures, or a combination of both may be used for maximum flexibility.

#### OSCAddressSpace with Method IDs

- Registration will return a unique ID token to correspond to each method that is registered. This can be stored and used to identify methods that ``OSCAddressSpace`` matches for you.
- When an OSC message is received:
  - Pass its address pattern to ``OSCAddressSpace/methods(matching:)``.
  - This method will pattern-match it against all registered local addresses and return an array of local method IDs that match.
  - You can then compare the IDs to ones you stored while registering the local methods.

```swift
// instance address space and register methods only once, usually at app startup.
let addressSpace = OSCAddressSpace()
let idMethodA = addressSpace.register(localAddress: "/methodA")
let idMethodB = addressSpace.register(localAddress: "/some/address/methodB")
```

```swift
func handle(message: OSCMessage) throws {
    let ids = addressSpace.methods(matching: message.addressPattern)
    
    try ids.forEach { id in
        switch id {
        case idMethodA:
            let str = try message.values.masked(String.self)
            performMethodA(str)
        case idMethodB:
            let (str, int) = try message.values.masked(String.self, Int?.self)
            performMethodB(str, int)
        default:
            print("Received unhandled OSC message:", message)
        }
    }
}

func performMethodA(_ str: String) { }
func performMethodB(_ str: String, _ int: Int?) { }
```

#### OSCAddressSpace with Method Closure Blocks

- When registering a local method, it can also store a closure. This closure can be executed automatically when matching against a received OSC message's address pattern.
- When an OSC message is received:
  - Pass its address pattern to the ``OSCAddressSpace/dispatch(_:)``.
  - This method will pattern-match it against all registered local addresses and execute their closures.
  - It also returns an array of local method IDs that match exactly like ``OSCAddressSpace/methods(matching:)`` (which may be discarded if handling of unregistered/unrecognized methods is not needed).
  - If the returned method ID array is empty, that indicates that no methods matched the address pattern. In this case you may want to handle the unhandled message in a special way.

```swift
// instance address space and register methods only once, usually at app startup.
let addressSpace = OSCAddressSpace()
addressSpace.register(localAddress: "/methodA") { values in
    guard let str = try? message.values.masked(String.self) else { return }
    performMethodA(str)
}
addressSpace.register(localAddress: "/some/address/methodB") { values in
    guard let (str, int) = try message.values.masked(String.self, Int?.self) else { return }
    performMethodB(str, int)
}
```

```swift
func handle(message: OSCMessage) throws {
    let ids = addressSpace.dispatch(message)
    if ids.isEmpty {
        print("Received unhandled OSC message:", message)
    }
}

func performMethodA(_ str: String) { }
func performMethodB(_ str: String, _ int: Int?) { }
```

## Topics

- ``OSCAddressPattern``
- ``OSCAddressSpace``
