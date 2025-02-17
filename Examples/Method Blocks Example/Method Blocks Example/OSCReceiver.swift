//
//  OSCReceiver.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import OSCKit

/// OSC receiver.
/// Registers local OSC addresses that our app is capable of recognizing and
/// handles received bundles & messages.
final class OSCReceiver: Sendable {
    private let addressSpace = OSCAddressSpace()
    
    public init() {
        // Register local OSC method and supply a closure block
        addressSpace.register(localAddress: "/methodA") { values, host, port in
            guard let str = try? values.masked(String.self) else { return }
            print("Received methodA from \(host):\(port) with value: \"\(str)\"")
        }
        
        // Register local OSC method and supply a closure block
        addressSpace.register(localAddress: "/some/address/methodB") { values, host, port in
            guard let (str, int) = try? values.masked(String.self, Int.self) else { return }
            print("Received methodB from \(host):\(port) with values: [\"\(str)\", \(int)]")
        }
        
        // Instead of supplying a closure, it's also possible to forward to a function:
        
        // Option 1: weak reference (recommended):
        addressSpace.register(
            localAddress: "/some/address/methodC",
            block: { [weak self] values, host, port in
                self?.handleMethodC(values: values, host: host, port: port)
            }
        )
        
        // Option 2: strong reference (discouraged):
        // addressSpace.register(
        //     localAddress: "/some/address/methodC",
        //     block: handleMethodC
        // )
    }
    
    private func handleMethodC(values: OSCValues, host: String, port: UInt16) {
        guard let (str, dbl) = try? values.masked(String.self, Double?.self) else { return }
        print("Received methodC from \(host):\(port) with values: [\"\(str)\", \(dbl as Any)]")
    }
    
    public func handle(message: OSCMessage, timeTag: OSCTimeTag, host: String, port: UInt16) throws {
        // Execute closures for matching methods, and returns the matching method IDs
        let methodIDs = addressSpace.dispatch(message: message, host: host, port: port)
        
        // If no IDs are returned, it means that the OSC message address pattern did not match any
        // that were registered
        if methodIDs.isEmpty {
            print("No method registered for:", message)
        }
    }
}
