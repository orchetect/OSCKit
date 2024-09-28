# ``OSCKitCore``

Open Sound Control (OSC) library for macOS, iOS and tvOS.

## Overview

![OSCKit](osckit-banner.png)

- OSC address pattern matching and dispatch
- Convenient OSC message value type masking, validation and strong-typing
- Modular: use the provided UDP network layer by default, or use your own
- Support for custom OSC types
- Supports Swift Concurrency
- Fully unit tested
- Full DocC documentation


- Tip: For a Getting Started guide, see the `OSCKit` module documentation.

@Comment {
    // -------------------------------------------------------------------
    // NOTE: The following is identical between the OSCKit and OSCKitCore
    // docc bundles, except that the OSCKit docc adds 'Getting Started'
    // and 'I/O' topic sections at the top of the Topics list.
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

- ``OSCObject``
- ``OSCObjectType``

### Advanced

- <doc:OSC-Custom-Types>
