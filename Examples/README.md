# OSCKit Examples

To make the library lightweight and flexible, OSCKit does not bundle any network I/O code. This allows you to use the network library of your chosing.

These example projects are provided to demonstrate using OSCKit with various common network libraries.

The [CocoaAsyncSocketExample](CocoaAsyncSocketExample) project is recommended as it is the easiest to adopt.

## Build Note

If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.