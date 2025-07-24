# ``OSCKit/OSCTCPClient``

### Setup

```swift
let tcpFramingMode: OSCTCPFramingMode = .osc1_1

let oscClient = OSCTCPClient(
    remoteHost: "192.168.1.20",
    remotePort: 3032,
    framingMode: tcpFramingMode
) { [weak self] message, timeTag, hostname, port in
    print("Received \(message) from server")
}
```

Then in order to connect to the remote server:

```swift
try oscClient.connect()
```

Once connected, messages may be sent and received bidirectionally between the client and server.

> Important:
>
> By default, OSCKit TCP classes use the OSC 1.1 SLIP packet framing mode.
> However, since there are two common framing modes used pervasively by hardware and software manufacturers,
> it is best practise to default to the latest (OSC 1.1 / SLIP) but provide the user the ability to select
> between the two in your application's user settings/preferences UI to maximize compatibility.

### Sending OSC Messages

See <doc:Sending-OSC> for details on how to send messages.
