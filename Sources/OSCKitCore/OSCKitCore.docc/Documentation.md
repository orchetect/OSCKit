# ``OSCKitCore``

Open Sound Control (OSC) library for macOS, iOS tvOS, and visionOS.

## Overview

![OSCKit](osckit-banner.png)

- OSC address pattern matching and dispatch
- Convenient OSC message value type masking, validation and strong-typing
- Modular: use the provided UDP or TCP network layer by default, or use your own
- Support for custom OSC types
- Supports Swift 6 Concurrency
- Fully unit tested
- Full DocC documentation

> Tip:
>
> For a Getting Started guide, see the `OSCKit` module documentation.

@Comment {
    // -------------------------------------------------------------------
    // NOTE: The following is identical between the OSCKit and OSCKitCore
    // docc bundles, except that the OSCKit docc adds 'Welcome' and 'I/O'
    // topic sections at the top of the Topics list.
    // -------------------------------------------------------------------
}

## Topics

### OSC Bundles

- ``OSCBundle``
- ``OSCTimeTag``

### OSC Messages

- ``OSCMessage``
- <doc:OSC-Address-Pattern-Parsing>
- <doc:OSC-Value-Types>
- <doc:OSC-Value-Parsing>

### OSC Data Protocol

- ``OSCPacket``
- ``OSCPacketType``

### Advanced

- <doc:OSC-Custom-Types>
