//
//  ViewController.swift
//  OSCKitExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Cocoa
import OSCKit

class ViewController: NSViewController {
    
    var oscClient: UDPClient?
    var oscServer: UDPServer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // OSC client setup
        
        oscClient = UDPClient(
            host: "localhost",
            port: 8000,
            queue: DispatchQueue.global(qos: .userInteractive)
        )
        
        print("UDP client set up.")
        
        // OSC server setup
        
        do {
            oscServer = try UDPServer(
                host: "localhost",
                port: 8000,
                queue: DispatchQueue.global(qos: .userInteractive)
            )
        } catch {
            print("Error initializing UDP server:", error)
            return
        }
        
        oscServer?.setHandler { [weak self] data in
            
            // incoming data handler is fired on the UDPServer's queue
            // but we want to deal with it on the main thread
            // to update UI as a result, etc. here
            
            DispatchQueue.main.async {
                
                do {
                    guard let oscPayload = try data.parseOSC() else { return }
                    try self?.handle(oscPayload: oscPayload)
                    
                } catch let error as OSCBundle.DecodeError {
                    // handle bundle errors
                    switch error {
                    case .malformed(let verboseError):
                        print("Error:", verboseError)
                    }
                    
                } catch let error as OSCMessage.DecodeError {
                    // handle message errors
                    switch error {
                    case .malformed(let verboseError):
                        print("Error:", verboseError)
                        
                    case .unexpectedType(let oscType):
                        print("Error: unexpected OSC type tag:", oscType)
                        
                    }
                    
                } catch {
                    // handle other errors
                    print("Error:", error)
                }
                
            }
            
        }
        
        print("UDP server set up.")
        
    }
    
    /// Handle incoming OSC data recursively
    func handle(oscPayload: OSCPayload) throws {
        
        switch oscPayload {
        case .bundle(let bundle):
            // recursively handle nested bundles and messages
            try bundle.elements.forEach { try handle(oscPayload: $0) }
            
        case .message(let message):
            // handle message
            try handle(oscMessage: message)
            
        }
        
    }
    
    func handle(oscMessage: OSCMessage) throws {
        
        switch oscMessage.address.pathComponents {
        case ["test", "method1"]:
            // validate and unwrap value array with expected types: [String]
            let value = try oscMessage.values.masked(String.self)
            print("/test/method1 with string:", value)
            
        case ["test", "method2"]:
            // validate and unwrap value array with expected types: [String, Int32?]
            let values = try oscMessage.values.masked(String.self, Int32?.self)
            print("/test/method2 with string: \(values.0), int32: \(values.1 ?? 0)")
            
        default:
            print(oscMessage)
        }
        
    }
    
    @IBAction func buttonSendOSCMessage(_ sender: Any) {
        
        let oscMessage = OSCMessage(
            address: "/testaddress",
            values: [.int32(123)]
        )
            .rawData
        
        oscClient?.send(data: oscMessage)
        
    }
    
}
