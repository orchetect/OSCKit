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
    
    private let idMethodA: OSCAddressSpace.MethodID
    private let idMethodB: OSCAddressSpace.MethodID
    private let idMethodC: OSCAddressSpace.MethodID
    
    public init() {
        // register local OSC methods and store the ID tokens once before receiving OSC messages
        idMethodA = addressSpace.register(localAddress: "/methodA")
        idMethodB = addressSpace.register(localAddress: "/some/address/methodB")
        idMethodC = addressSpace.register(localAddress: "/some/address/methodC")
    }
    
    public func handle(message: OSCMessage, timeTag: OSCTimeTag) throws {
        let ids = addressSpace.methods(matching: message.addressPattern)
        
        guard !ids.isEmpty else {
            // No matches against any registered local OSC addresses.
            print(message, "with time tag:", timeTag)
            return
        }
        
        try ids.forEach { id in
            switch id {
            case idMethodA:
                let str = try message.values.masked(String.self)
                performMethodA(str)
                
            case idMethodB:
                let (str, int) = try message.values.masked(String.self, Int.self)
                performMethodB(str, int)
                
            case idMethodC:
                let (str, dbl) = try message.values.masked(String.self, Double?.self)
                performMethodC(str, dbl)
                
            default:
                break
            }
        }
    }
    
    private func performMethodA(_ str: String) {
        print("Dispatching methodA with value: \"\(str)\"")
    }
    
    private func performMethodB(_ str: String, _ int: Int) {
        print("Dispatching methodB with values: [\"\(str)\", \(int)]")
    }
    
    private func performMethodC(_ str: String, _ dbl: Double?) {
        print("Dispatching methodC with values: [\"\(str)\", \(dbl as Any)]")
    }
}
