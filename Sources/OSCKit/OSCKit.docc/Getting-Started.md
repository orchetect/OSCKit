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

- term ``OSCUDPClient``: Send OSC messages over UDP.
- term ``OSCUDPServer``: Receive OSC messages over UDP.
- term ``OSCUDPSocket``: Send and receive OSC messages over UDP using a single local port.

## Value Types

- <doc:OSC-Value-Types>

## Sending and Receiving

- <doc:Sending-OSC>
- <doc:Receiving-OSC>
  - <doc:OSC-Address-Pattern-Parsing>
  - <doc:OSC-Value-Parsing>

## Example Code

The [Examples](https://github.com/orchetect/OSCKit/tree/main/Examples) folder contains projects to quickly get started.
