//
//  AppDelegate.swift
//  OSCKitExample
//  OSCKit • https://github.com/orchetect/OSCKit
//

import Cocoa
import OSCKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let oscClient = OSCClient()
    let oscServer = OSCServer(port: 8000)
    let oscReceiver = OSCReceiver()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupOSCServer()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscServer.stop()
    }
    
    /// Call once at app startup.
    private func setupOSCServer() {
        oscServer.setHandler { [weak self] oscMessage in
            do {
                try self?.oscReceiver.handle(oscMessage: oscMessage)
            } catch {
                print(error)
            }
        }
        
        do {
            try oscServer.start()
        } catch {
            print(error)
        }
    }
    
    /// Send a test OSC message.
    @IBAction func sendTestOSCMessage(_ sender: Any) {
        let oscMessage = OSCMessage(
            address: "/some/address/methodB",
            values: [.string("Test string"), .int32(123)]
        )
        
        oscClient.send(
            oscMessage,
            to: "127.0.0.1", // local machine
            port: 8000 // standard OSC port but can be changed
        )
    }
}
