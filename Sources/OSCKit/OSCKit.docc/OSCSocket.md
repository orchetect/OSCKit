# ``OSCKit/OSCSocket``

### Setup

If not specified during initialization, the local port will be randomly assigned by the system. The same port will be used to both listen for incoming events and send outgoing events _from_. Either way, this port may only be specified at the time of initialization.

The remote port may be omitted, in which case the same port number as the local port will be used. The remote port may be overridden if supplied as a parameter when calling ``OSCSocket/send(_:to:port:)``.

```swift
// this would be a typical setup to interact with a remote Behringer X32.
// randomly generate a local port, but always send messages to remote port 10023.
let socket = OSCSocket(
    remoteHost: "192.168.0.2",
    remotePort: 10023
) { message, timeTag in
    print("Received \(message)")
}
```

Similar to ``OSCServer``, an ``OSCSocket`` instance must be started before it can send or receive messages.

```swift
try socket.start()
```

### Sending and Receiving OSC Messages

See <doc:Sending-OSC> and <doc:Receiving-OSC> for details on how to send and receive messages.

### Addenda on Sending using OSCSocket

The ``OSCSocket/send(_:to:port:)`` method may be used to send OSC messages and bundles.

```swift
// The remoteHost and/or remotePort supplied at the itme of
// initialization will be used by default:
try socket.send(osc)

// It is also possible to override the destination host and/or port
// on a per-message basis:
try socket.send(osc, to: "192.168.0.3", port: 8000)
```

### Notes

> OSC 1.0 Spec:
>
> With regards OSC Bundle Time Tag:
>
> An OSC server must have access to a representation of the correct current absolute time. OSC
> does not provide any mechanism for clock synchronization. If the time represented by the OSC
> Time Tag is before or equal to the current time, the OSC Server should invoke the methods
> immediately. Otherwise the OSC Time Tag represents a time in the future, and the OSC server
> must store the OSC Bundle until the specified time and then invoke the appropriate OSC
> Methods. When bundles contain other bundles, the OSC Time Tag of the enclosed bundle must be
> greater than or equal to the OSC Time Tag of the enclosing bundle.
