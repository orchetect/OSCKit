//
//  AppDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
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
        oscServer.setHandler { [weak self] message, timeTag in
            do {
                try self?.oscReceiver.handle(
                    message: message,
                    timeTag: timeTag
                )
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
    @IBAction
    func sendTestOSCMessage(_ sender: Any) {
        let oscMessage = OSCMessage(
            "/some/address/methodB",
            values: ["Test string", 123]
        )
        
        try? oscClient.send(
            oscMessage,
            to: "localhost", // IP address or hostname
            port: 8000 // standard OSC port but can be changed
        )
    }
}
