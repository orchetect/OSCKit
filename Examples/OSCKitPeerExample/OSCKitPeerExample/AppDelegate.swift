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
    var port: UInt16?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) { }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscPeer?.stop()
    }
    
    @IBAction
    func startOSCPeerWithPort(_ sender: Any?) {
        guard let port = port, (1 ... 65335).contains(port) else {
            print("Press enter a valid port number first.")
            return
        }
        startOSCPeer(sender)
    }
    
    @IBAction
    func startOSCPeerWithRandomPort(_ sender: Any?) {
        port = nil
        startOSCPeer(sender)
    }
    
    @IBAction
    func startOSCPeer(_ sender: Any?) {
        print("Starting OSC peer.")
        do {
            let newPeer = OSCPeer(host: "localhost", port: port) { message, timeTag in
                print(message, "with time tag: \(timeTag)")
            }
            oscPeer = newPeer
            try newPeer.start()
            print("Using port \(newPeer.port).")
        } catch {
            print("Error while starting OSC peer with port \(port as Any): \(error)")
        }
    }
    
    @IBAction
    func stopOSCPeer(_ sender: Any?) {
        print("Stopping OSC peer.")
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

class ViewController: NSViewController {
    @IBOutlet weak var portNumber: NSTextField!
    
    @IBAction
    func startOSCPeerWithPort(_ sender: Any?) {
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        appDelegate?.port = UInt16(portNumber.intValue)
        
        NSApp.sendAction(#selector(AppDelegate.startOSCPeerWithPort(_:)),
                         to: appDelegate,
                         from: self)
    }
}
