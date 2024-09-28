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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) { }
    
    func applicationWillTerminate(_ aNotification: Notification) { }
    
    @IBAction
    func startOSCPeer(_ sender: Any?) {
        oscManager.start()
    }
    
    @IBAction
    func stopOSCPeer(_ sender: Any?) {
        oscManager.stop()
    }
    
    /// Send a test OSC message.
    @IBAction
    func sendTestOSCMessage(_ sender: Any?) {
        oscManager.send(
            .message("/some/address/method", values: ["Test string", 123])
        )
    }
}
