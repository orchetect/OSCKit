# ``OSCKit``

Open Sound Control (OSC) library for macOS, iOS and tvOS.

## Overview

![OSCKit](osckit-banner.png)

- OSC address pattern matching and dispatch
- Convenient OSC message value type masking, validation and strong-typing
- Modular: use the provided UDP network layer by default, or use your own
- Support for custom OSC types
- Thread-safe
- Fully unit tested
- Full DocC documentation

@Comment {
    // -------------------------------------------------------------------
    // NOTE: The following is identical between the OSCKit and OSCKitCore
    // docc bundles, except that the OSCKit docc adds 'Getting Started'
    // and 'I/O' topic sections at the top of the Topics list.
    // -------------------------------------------------------------------
}

## Topics

### Getting Started
- <doc:Getting-Started>
- <doc:Sending-OSC>
- <doc:Receiving-OSC>

### OSC I/O Objects

- ``OSCClient``
- ``OSCServer``
- ``OSCSocket``
- ``OSCTimeTagMode``

### OSC Bundles

- ``OSCBundle``
- ``OSCTimeTag``

### OSC Messages

- ``OSCMessage``
- <doc:OSC-Address-Pattern-Parsing>
- <doc:OSC-Value-Types>
- <doc:OSC-Value-Parsing>

### OSC Data Protocol

- ``OSCObject``
- ``OSCObjectType``

### Advanced

- <doc:OSC-Custom-Types>
