# ``OSCKitCore/OSCAddressSpace``

## Topics

### Initializers

- ``init()``
- ``init(methodIDs:)``

### Method Registration (UUID)

- ``register(localAddress:block:)-(String,_)``
- ``register(localAddress:block:)-(S,_)``

### Method Registration (Custom ID)

- ``register(localAddress:id:block:)-(String,_,_)``
- ``register(localAddress:id:block:)-(S,_,_)``

### Method Unregistration

- ``unregister(localAddress:)-(String)``
- ``unregister(localAddress:)-(S)``
- ``unregister(methodID:)``
- ``unregisterAll()``

### Address Parsing

- ``methods(matching:)``
- ``dispatch(message:host:port:)``
