# Getting Started

Getting started with using OSCKit in your application.

## Import the Library

Import the library:

```swift
import OSCKit
```

Or to import OSCKit without networking I/O in order to implement your own sockets:

```swift
import OSCKitCore
```

## Classes

- term ``OSCClient``: Send OSC messages.
- term ``OSCServer``: Receive OSC messages.
- term ``OSCSocket``: Send and receive OSC messages using a single local port.

## Value Types

- <doc:OSC-Value-Types>

## Sending and Receiving

- <doc:Sending-OSC>
- <doc:Receiving-OSC>
  - <doc:OSC-Address-Pattern-Parsing>
  - <doc:OSC-Value-Parsing>

## Example Code

The [Examples](https://github.com/orchetect/OSCKit/tree/main/Examples) folder contains projects to quickly get started.
