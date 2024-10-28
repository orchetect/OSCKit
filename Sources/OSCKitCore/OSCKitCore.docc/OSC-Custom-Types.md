# Custom OSC Value Types

OSCKit supports custom OSC message value types.

@Comment {
    // -------------------------------------------------------------------
    // NOTE: This file is duplicated in both OSCKit and OSCKitCore targets.
    //         Ensure both files are updated when making changes.
    // -------------------------------------------------------------------
}

## Overview

Implementing custom OSC value types is possible but is an advanced feature and not recommended unless there are special use cases.

OSCKit provides built-in support for all standard value types and in nearly all use cases they are sufficient. (See <doc:OSC-Value-Types> for a full list of value types already supported by OSCKit.)

Note that custom value types are proprietary and only your software will be able to understand them.

## Implementation

In order for a custom type to be usable as an OSC message value:

1. It must conform to the ``OSCValue`` protocol.
   - This implies that the type also conform to `Equatable`, `Hashable`, `Sendable`, ``OSCValueCodable`` and ``OSCValueMaskable``.
   - See the `OSCKitCustomTypeExample` example project for a sample implementation.
   - See the `/Sources/OSCKitCore/OSCValue/` folder for examples of how the protocol adoptions have been implemented internally for existing types.
2. It must be registered with the global ``OSCSerialization`` singleton.
   - Call ``OSCSerialization/registerType(_:)`` and pass `YourType.self` once at app startup.
   - This registration informs OSCKit of your type and allows OSC message decoding and compatibility with the `masked()` method.

## Topics

### Protocols

- ``OSCValue``
- ``OSCInterpolatedValue``
- ``OSCValueCodable``
- ``OSCValueDecodable``
- ``OSCValueEncodable``
- ``OSCValueMaskable``

### Encoding and Decoding

- ``OSCValueDecoder``
- ``OSCValueDecoderBlock``
- ``OSCValueEncoderBlock``
- ``OSCMessageEncoder``

### Encoders and Decoders

- ``OSCValueTagIdentity``
- ``OSCValueAtomicDecoder``
- ``OSCValueAtomicEncoder``
- ``OSCValueVariableDecoder``
- ``OSCValueVariableEncoder``
- ``OSCValueVariadicDecoder``
- ``OSCValueVariadicEncoder``

### Errors

- ``OSCDecodeError``
- ``OSCEncodeError``

### Serialization

- ``OSCSerialization``
- ``OSCSerializationError``
