# ``OSCKit/OSCTCPServer``

### Setup

```swift
let oscServer: OSCTCPServer
let tcpFramingMode: OSCTCPFramingMode = .osc1_1

init() {
    oscServer = OSCTCPServer(
        localPort: 3032,
        framingMode: tcpFramingMode
    ) { [weak self] message, timeTag, client, port in
        print("Received \(message) from client \(client)")
    }
}
```

Connection state notifications can be observed by providing a handler closure:

```swift
oscServer.setNotificationHandler { [weak self] notification in
    switch notification {
        // ...
    }
}
```

Then in order to bind to the local network port and begin listening for inbound connections:

```swift
// call this once, usually during your app's startup
try oscServer.start()
```

Inbound client connections are automatically accepted. One or more remote clients may be connected to a single
local server at the same time, each with their own independent bidirectional connection to the server.

OSC messages and bundles may be sent to all clients at once, or sent to individual clients discretely.

> Important:
>
> By default, OSCKit TCP classes use the OSC 1.1 SLIP packet framing mode.
> However, since there are two common framing modes used pervasively by hardware and software manufacturers,
> it is best practise to default to the latest (OSC 1.1 / SLIP) but provide the user the ability to select
> between the two in your application's user settings/preferences UI to maximize compatibility.

### Receiving OSC Messages

See <doc:Receiving-OSC> for details on how to receive messages.
