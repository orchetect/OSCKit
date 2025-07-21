# Receiving OSC

Receiving OSC messages and bundles.

## Overview

Both ``OSCUDPServer`` and ``OSCUDPSocket`` are capable of receiving messages using the same API.

If not already set during initialization, you may set the receiver handler using the ``OSCUDPServer/setHandler(_:)`` or ``OSCUDPServer/setHandler(_:)`` method.

```swift
oscServer.setHandler { [weak self] message, timeTag, host, port in
    do {
        try self?.handle(message: message, host: host, port: port)
    } catch {
        print(error)
    }
}

private func handle(message: OSCMessage, host: String, port: UInt16) throws {
    // handle received messages here
}
```

Then start the server/socket to begin listening for inbound OSC packets.

```swift
// call this once, usually during your app's startup
try oscServer.start()
```

If received OSC bundles contain a future time tag and the `OSCUDPServer` is set to `.osc1_0` mode, these bundles will be held in memory automatically and scheduled to be dispatched to the handler at the future time.

Note that as per the OSC 1.1 proposal, this behavior has largely been deprecated. `OSCUDPServer` will default to `.ignore` and not perform any scheduling unless explicitly set to `.osc1_0` mode.

## Topics

- <doc:OSC-Address-Pattern-Parsing>
- <doc:OSC-Value-Parsing>
