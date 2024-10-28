# OSC Value Types

OSC Message value types.

@Comment {
    // -------------------------------------------------------------------
    // NOTE: This file is duplicated in both OSCKit and OSCKitCore targets.
    //         Ensure both files are updated when making changes.
    // -------------------------------------------------------------------
}

## Overview

The following OSC value types are available, conforming to the [Open Sound Control 1.0 specification](http://opensoundcontrol.org/spec-1_0.html).

The _Syntax_ columns below provide easy reference for how to construct them.

### Core OSC Types

| Core OSC Type           | Swift Concrete Type | Standard Syntax | Convenience Syntax |
| ----------------------- | ------------------- | --------------- | ------------------ |
| int32, big-endian       | `Int32`             | `Int32(...)`    | -                  |
| float32, big-endian     | `Float32`           | `Float32(...)`  | -                  |
| string, null-terminated | `String`            | `String(...)`   | `String` literal   |
| blob, null-terminated   | `Data`              | `Data(...)`     | -                  |

### Extended OSC Types

| Extended OSC Type         | Swift Concrete Type   | Standard Syntax               | Convenience Syntax     |
| ------------------------- | --------------------- | ----------------------------- | ---------------------- |
| bool                      | `Bool`                | `true`, `false`               | -                      |
| int64, big-endian         | `Int64`               | `Int64(...)`                  | -                      |
| double, big-endian        | `Double`              | `Double(...)`                 | -                      |
| ASCII char                | `Character`           | `Character(...)`              | `Character` literal    |
| `[`...`]`                 | ``OSCArrayValue``     | `OSCArrayValue([...])`        | `.array([...])`        |
| uint64, big-endian        | ``OSCTimeTag``        | `OSCTimeTag(1)`               | `.timeTag(1)`          |
| string, null-terminated   | ``OSCStringAltValue`` | `OSCStringAltValue("String")` | `.stringAlt("String")` |
| 4-byte MIDI channel voice | ``OSCMIDIValue``      | `OSCMIDIValue(...)`           | `.midi(...)`           |
| impulse/infinitum/bang    | ``OSCImpulseValue``   | `OSCImpulseValue()`           | `.impulse`             |
| null                      | ``OSCNullValue``      | `OSCNullValue()`              | `.null`                |

### Interpolated OSC Types

OSCKit adds the following interpolated types. These types can be used directly and they will transparently encode and decode to compatible core OSC types on-the-fly. This is provided as a convenience and requires no extra handling.

| Type              | Encoding Type                                       |
| ----------------- | --------------------------------------------------- |
| `Int`             | `Int32` (core type), converting any `BinaryInteger` |
| `Int8`            | `Int32` (core type)                                 |
| `Int16`           | `Int32` (core type)                                 |
| `UInt`            | `Int64` (core type)                                 |
| `UInt8`           | `Int32` (core type)                                 |
| `UInt16`          | `Int32` (core type)                                 |
| `UInt32`          | `Int64` (core type)                                 |
| `Float16`         | `Float32` (core type)                               |
| `Float80`         | `Double` (extended type)                            |
| `Substring`       | `String` (core type)                                |

### Type-Erased OSC Types

OSCKit also adds the following opaque type-erasure types.

| Type                  | Description                                          |
| --------------------- | ---------------------------------------------------- |
| ``AnyOSCNumberValue`` | Wraps any `BinaryInteger` or `BinaryFloatingPoint`. Used when masking OSC values to mask a type-erased number, and is not meant to be constructed directly. |

## Topics

- ``OSCValue``
- ``OSCValues``
- ``AnyOSCNumberValue``
- ``OSCArrayValue``
- ``OSCImpulseValue``
- ``OSCMIDIValue``
- ``OSCNullValue``
- ``OSCStringAltValue``
