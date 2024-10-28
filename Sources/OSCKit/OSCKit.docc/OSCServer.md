# ``OSCKit/OSCServer``

### Setup

```swift
let oscServer: OSCServer

init() {
    oscServer = OSCServer(port: 8000) { [weak self] message, timeTag in
        print("Received \(message)")
    }
}
```

### Receiving OSC Messages

See <doc:Receiving-OSC> for details on how to receive messages.

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
