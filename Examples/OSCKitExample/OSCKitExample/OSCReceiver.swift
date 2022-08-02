//
//  OSCReceiver.swift
//  OSCKitExample
//
//  Created by Steffan Andrews on 2022-08-01.
//

import OSCKit

class OSCReceiver {
    private let oscDispatcher = OSCDispatcher()
    
    private let idMethodA: OSCDispatcher.MethodID
    private let idMethodB: OSCDispatcher.MethodID
    private let idMethodC: OSCDispatcher.MethodID
    
    public init() {
        // register local OSC methods and store the ID tokens once before receiving OSC messages
        idMethodA = oscDispatcher.register(address: "/methodA")
        idMethodB = oscDispatcher.register(address: "/some/address/methodB")
        idMethodC = oscDispatcher.register(address: "/some/address/methodC")
    }
    
    public func handle(oscMessage: OSCMessage) throws {
        let ids = oscDispatcher.methods(matching: oscMessage.address)
        
        guard !ids.isEmpty else {
            print("Received unrecognized OSC message:", oscMessage)
            return
        }
        
        try ids.forEach { id in
            switch id {
            case idMethodA:
                let value = try oscMessage.values.masked(String.self)
                performMethodA(value)
                
            case idMethodB:
                let values = try oscMessage.values.masked(String.self, Int.self)
                performMethodB(values.0, values.1)
                
            case idMethodC:
                let values = try oscMessage.values.masked(String.self, Double?.self)
                performMethodC(values.0, values.1)
                
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
