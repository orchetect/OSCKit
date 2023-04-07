//
//  AppDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var oscPeer: OSCPeer?
    
    let port: UInt16 = 8000
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        oscPeer = OSCPeer(host: "localhost", port: port) { message, timeTag in
            print(message, "with time tag: \(timeTag)")
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscPeer?.stop()
    }
    
    @IBAction
    func startOSCPeer(_ sender: Any?) {
        do {
            try oscPeer?.start()
        } catch {
            print("Error while starting OSC peer with local port \(port): \(error)")
        }
    }
    
    @IBAction
    func stopOSCPeer(_ sender: Any?) {
        oscPeer?.stop()
    }
    
    /// Send a test OSC message.
    @IBAction
    func sendTestOSCMessage(_ sender: Any?) {
        do {
            try oscPeer?.send(
                .message("/some/address/method", values: ["Test string", 123])
            )
        } catch {
            print("Error while sending: \(error)")
        }
    }
}
