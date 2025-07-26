# OSCKit TCP Client and Server Example

This example demonstrates the use of the TCP protocol to send and receive OSC messages.

It will build for all platforms including macOS, iOS, tvOS and visionOS, and can be run in device simulators.

## Entitlements

If you are adding OSCKit to a macOS project that has the Sandbox entitlement, ensure that the network options are enabled. These entitlement options are already set in the example project.

![sandbox-network-connections](../../Images/sandbox-network-connections.png)

## Build Note

> [!TIP]
> 
>If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.
