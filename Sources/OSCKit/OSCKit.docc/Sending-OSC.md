# Sending OSC

Sending OSC messages and bundles.

## Overview

Both ``OSCClient`` and ``OSCSocket`` are capable of sending messages using the same API.

Note that the `send(_:to:port:)` method on ``OSCClient`` is globally thread-safe.

### OSC Messages

To send a single message, construct an ``OSCMessage`` and send it using the client or socket instance.

```swift
let msg = OSCMessage("/test", values: ["string", 123])

try oscClient.send(msg, to: "192.168.1.2", port: 8000)
```

### OSC Bundles

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
