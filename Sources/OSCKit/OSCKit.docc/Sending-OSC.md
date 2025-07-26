# Sending OSC

Sending OSC messages and bundles.

## Overview

## UDP

For the UDP protocol, both ``OSCUDPClient`` and ``OSCUDPSocket`` are capable of sending messages using the same API.

```swift
try oscClient.send(/* ... */, to: "192.168.1.2", port: 8000)
```

See [OSC Messages](#OSC-Messages) and [OSC Bundles](#OSC-Bundles) below for details on how to construct messages and bundles.

## TCP

For the TCP protocol, both ``OSCTCPClient`` and ``OSCTCPServer`` are capable of sending messages using slightly different API.

### TCP Client

Ensure the client is connected to the remote server first (see ``OSCTCPClient`` docs), then you can begin sending data.

```swift
try oscClient.send(/* ... */)
```

### TCP Server

Ensure the server is started first (see ``OSCTCPServer`` docs), then you can begin sending data to connected clients after they have established a connection.

```swift
// send an OSC bundle or message to all currently connected clients
try oscServer.send(/* ... */)
```

```swift
// send an OSC bundle or message to one or more currently connected clients

// (this is provided simply as an example and should not be typical usage.
// it may be better practise to implement your own handshaking using OSC
// messages in order for a client to identify itself to the server and be
// paired with its client ID, and not rely on host/IP which may be brittle)

// clients currently connected can be queried from the server instance
let clientIDs = oscServer.clients
    .filter { $0.value.host == "192.168.1.20" } // find the client(s) you want
    .keys // returns array of client IDs
try oscServer.send(/* ... */, toClientIDs: clientIDs)
```

Note that client IDs are transient and only valid for the lifecycle of the connection. These IDs are randomly generated for each connection session and therefore should not be stored persistently or used beyond the scope of identifying currently-connected clients. (See ``OSCTCPClientSessionID``)

See [OSC Messages](#OSC-Messages) and [OSC Bundles](#OSC-Bundles) below for details on how to construct messages and bundles.

## OSC Messages

To send a single message, construct an ``OSCMessage`` and send it using the client or socket instance.

```swift
let msg = OSCMessage("/test", values: ["string", 123])

try oscClient.send(msg, to: "192.168.1.2", port: 8000)
```

## OSC Bundles

To send multiple OSC messages or nested OSC bundles to the same destination at the same time, pack them in an `OSCBundle` and send it using the client or socket instance.

```swift
// Option 1: build elements separately
let msg1 = OSCMessage("/msg1")
let msg2 = OSCMessage("/msg2", values: ["string", 123])
let bundle = OSCBundle([msg1, msg2])

// Option 2: build elements inline
let bundle = OSCBundle([
    .message("/msg1"),
    .message("/msg2", values: ["string", 123])
])

// send the bundle
try oscClient.send(bundle, to: "192.168.1.2", port: 8000)
```

### Sending OSC Bundles with a Future Time Tag

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
