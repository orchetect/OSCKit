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

## Topics

### I/O

- ``OSCClient``
- ``OSCServer``
- ``OSCSocket``
- ``OSCTimeTagMode``

### OSC Message

- ``OSCMessage``
- ``OSCAddressPattern``

### OSC Bundle

- ``OSCBundle``
- ``OSCTimeTag``

### OSC Data Protocol

- ``OSCObject``

### OSC Message Values

- ``AnyOSCValue``
- ``OSCValue``
- ``OSCValues``
- ``AnyOSCNumberValue``
- ``OSCArrayValue``
- ``OSCImpulseValue``
- ``OSCMIDIValue``
- ``OSCNullValue``
- ``OSCStringAltValue``

### OSC Value Masking

- ``OSCValueToken``
- ``OSCValueMaskError``

### OSC Address Space

- ``OSCAddressSpace``

### OSC Serialization

- ``OSCSerialization``
- ``OSCSerializationError``

### Implementing Custom OSC Values

- ``OSCValueAtomicDecoder``
- ``OSCValueAtomicEncoder``
- ``OSCValueCodable``
- ``OSCValueDecodable``
- ``OSCValueDecoder``
- ``OSCValueDecoderBlock``
- ``OSCValueEncodable``
- ``OSCValueEncoderBlock``
- ``OSCValueTagIdentity``
- ``OSCValueVariableDecoder``
- ``OSCValueVariableEncoder``
- ``OSCValueVariadicDecoder``
- ``OSCValueVariadicEncoder``
- ``OSCInterpolatedValue``
- ``OSCNumberValueBase``
- ``OSCValueMaskable``
- ``OSCMessageEncoder``

### Internals

- ``OSCDecodeError``
- ``OSCEncodeError``
- ``OSCObjectType``
