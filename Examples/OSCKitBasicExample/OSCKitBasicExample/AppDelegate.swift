//
//  AppDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let oscClient = OSCClient()
    let oscServer = OSCServer(port: 8000)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        oscServer.setHandler { message, timeTag in
            print(message, "with time tag:", timeTag)
        }
        
        try? oscServer.start()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscServer.stop()
    }
    
    /// Send a test OSC message.
    @IBAction
    func sendTestOSCMessage(_ sender: Any) {
        try? oscClient.send(
            .message("/some/address/methodB", values: ["Test string", 123]),
            to: "localhost", // IP address or hostname
            port: 8000 // standard OSC port but can be changed
        )
    }
}
