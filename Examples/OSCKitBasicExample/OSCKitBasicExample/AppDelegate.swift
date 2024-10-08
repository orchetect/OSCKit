//
//  AppDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let oscManager = OSCManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        oscManager.start()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscManager.stop()
    }
}

extension AppDelegate {
    /// Send a test OSC message.
    @IBAction
    func sendTestOSCMessage(_ sender: Any) {
        oscManager.send(
            .message("/some/address/method", values: ["Test string", 123]),
            to: "localhost", // destination IP address or hostname
            port: 8000 // standard OSC port but can be changed
        )
    }
}
