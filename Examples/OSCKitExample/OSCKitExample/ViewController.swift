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
                    self?.handleOSCPayload(oscPayload)
                    
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
    func handleOSCPayload(_ oscPayload: OSCPayload) {
        
        switch oscPayload {
        case .bundle(let bundle):
            // recursively handle nested bundles and messages
            bundle.elements.forEach { handleOSCPayload($0) }
            
        case .message(let message):
            // handle message
            print(message)
            
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

