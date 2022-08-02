//
//  AppDelegate.swift
//  OSCKitCASExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Cocoa
import OSCKitCAS

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var oscClient = OSCClient()
    var oscServer = OSCServer(port: 8000) 
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupOSCServer()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscServer.stop()
    }
    
    /// Call once at app startup.
    private func setupOSCServer() {
        oscServer.setHandler { [weak self] oscMessage in
            // Important: handle received OSC on main thread if it may result in UI updates
            DispatchQueue.main.async {
                do {
                    try self?.handle(received: oscMessage)
                } catch {
                    print(error)
                }
            }
        }
        
        do {
            try oscServer.start()
        } catch {
            print(error)
        }
    }
}

// MARK: - OSC Send and Receive

extension AppDelegate {
    /// Parses received OSC messages.
    private func handle(received oscMessage: OSCMessage) throws {
        switch oscMessage.address.pathComponents {
        case ["test", "method1"]:
            // validate and unwrap value array with expected types: [String]
            let value = try oscMessage.values.masked(String.self)
            print("Matched /test/method1 with string:", value)
            
        case ["test", "method2"]:
            // validate and unwrap value array with expected types: [String, Int32?]
            let values = try oscMessage.values.masked(String.self, Int32?.self)
            print("Matched /test/method2 with string: \"\(values.0)\", int32: \(values.1 ?? 0)")
            
        default:
            print(oscMessage)
        }
    }
    
    /// Send a test OSC message.
    @IBAction func sendTestOSCMessage(_ sender: Any) {
        let oscMessage = OSCMessage(
            address: "/test/method2",
            values: [.string("Test string."), .int32(123)]
        )
        
        oscClient.send(
            oscMessage,
            to: "127.0.0.1", // local machine
            port: 8000 // standard OSC port but can be changed
        )
    }
}
