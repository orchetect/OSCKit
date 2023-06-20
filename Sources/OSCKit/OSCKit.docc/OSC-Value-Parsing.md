# OSC Value Parsing

Methods for parsing OSC Message value collections.

@Comment {
    // -------------------------------------------------------------------
    // NOTE: This file is duplicated in both OSCKit and OSCKitCore targets.
    //         Ensure both files are updated when making changes.
    // -------------------------------------------------------------------
}

### Using masked() to validate and unwrap expected value types

Since local OSC "addresses" (OSC Methods) are generally considered methods (akin to functions) which take parameters (OSC values/arguments), in most use cases an OSC Method will have a defined type mask. OSCKit provides a powerful and flexible API to both validate and strongly type an OSC value array.

Validate and unwrap value array with expected member `String`:

```swift
let str = try oscMessage.values.masked(String.self)
print("string: \(str)")
```

The special wrapper type `AnyOSCNumberValue` is able to match any number and provides easy type-erased access to its contents, converting value types if necessary automatically.

Validate and unwrap value array with expected members `String, Int, <number>?`:

```swift
let (str, int, num) = try oscMessage.values.masked(
    String.self, Int.self, AnyOSCNumberValue?.self
)
print(str, int, num?.intValue)
print(str, int, num?.doubleValue)
print(str, int, num?.base) // access to the strongly typed integer or floating-point value
```

### Using matches(mask:) to test for a mask with type tokens

If value unwrapping is not needed, a mere test of value types in an OSC value sequence can be done using a mask of ``OSCValueToken`` tokens.

This can be useful at barriers in more complex codebases where early return or error-throwing due to mismatching value masks may be wanted before the values are ever unwrapped and statically typed.

```swift
// [String, Int, AnyOSCNumberValue?]
guard oscMessage.values.matches(
    mask: [.string, .int, .numberOptional]
) else { return }
```

### Manually unwrapping expected value types

It is generally easier to use `masked()` as demonstrated above, since it handles masking, strongly typing, as well as translation of interpolated (`Int8`, `Int16`, etc.) and opaque (`AnyOSCNumberValue`, etc.) types. However the following is generally functionally equivalent.

Validate and unwrap value array with expected member `String`:

```swift
guard oscMessage.values.count == 1 else { ... }
guard let str = oscMessage.values[0] as? String else { ... } // compulsory
print(str) // String
```

Validate and unwrap value array with expected members `String, Int32?, Double?`:

```swift
guard (1...3).contains(oscMessage.values.count) else { ... }
guard let str = oscMessage.values[0] as? String else { ... } // compulsory
let int: Int32? = oscMessage.count > 1 ? oscMessage.values[1] as? Int32 : nil // optional
let dbl: Double? = oscMessage.count > 2 ? oscMessage.values[2] as? Double : nil // optional
print(str, int, dbl) // String, Int32?, Double?
```

### Parsing a variable number of values

It may be desired to imperatively validate and cast values when their expected mask may be unknown.

```swift
oscMessage.values.forEach { oscValue in
    switch oscValue {
    case let val as String:
        print(val)
    case let val as Int32:
        print(val)
    default:
        // unhandled
    }
}
```

## 

## Topics

- ``OSCValueToken``
- ``OSCValueMaskError``
