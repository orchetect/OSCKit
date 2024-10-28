# OSCKit Custom Type Example

This example demonstrates conforming a custom type to become OSC codable as an OSC message value.

> [!IMPORTANT]
>
> This is an advanced feature and _**in almost every use case**_, it is not necessary to conform a custom type.
>
> The standard data types available for use defined by the OSC spec cover most common data types for most conceivable use cases. Using data types defined by the OSC spec means 3rd-party software/hardware will recognize them as a native type.
>
> While it is possible to define your own OSC Type, it is discouraged by the OSC spec. Only your own software will understand this OSC Type because you have to provide the encoding and decoding implementation logic. This of course means this type can only be sent and received by software that you create containing this implementation. 3rd-party software/hardware receiving OSC messages containing this custom type will ignore it.
>
> Another consideration is that only compact data types should be conformed as an OSC Type. Since the UDP packet size is the upper limit of the amount of data that can be encoded, be aware that custom types that could potentially encode to raw data that overflows UDP packet size will fail to send on the network.
>
> This example project is provided as a starting point for demonstrating how to conform a custom type as an OSC Type.
>
> The example implementation is the same protocolized interface OSCKit uses under the hood to conform all of its standard OSC Types. To see examples of more advanced implementations, see the [`OSCKitCore/OSCValue`](../../Sources/OSCKitCore/OSCValue) source contents.

## Entitlements

If you are adding OSCKit to a macOS project that has the Sandbox entitlement, ensure that the network options are enabled. These entitlement options are already set in the example project.

![sandbox-network-connections](../../Images/sandbox-network-connections.png)

## Build Note

> [!TIP]
> 
>If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.
