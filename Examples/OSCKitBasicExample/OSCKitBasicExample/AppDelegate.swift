//
//  AppDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let oscClient = OSCClient()
    let oscServer = OSCServer(port: 8000)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // setup server
        
        oscServer.setHandler { message, timeTag in
            print(message, "with time tag:", timeTag)
        }
        // oscServer.isPortReuseEnabled = true
        do { try oscServer.start() } catch { print(error) }
        
        // setup client
        
        // oscClient.isPortReuseEnabled = true
        // oscClient.isIPv4BroadcastEnabled = true
        do { try oscClient.start() } catch { print(error) }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscServer.stop()
    }
    
    /// Send a test OSC message.
    @IBAction
    func sendTestOSCMessage(_ sender: Any) {
        try? oscClient.send(
            .message("/some/address/method", values: ["Test string", 123]),
            to: "localhost", // remote IP address or hostname
            port: 8000 // standard OSC port but can be changed
        )
    }
}
