//
//  AppDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var oscPeer: OSCPeer?
    var localPort: UInt16?
    var remoteHost: String = ""
    var remotePort: UInt16?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) { }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscPeer?.stop()
    }
    
    @IBAction
    func startOSCPeer(_ sender: Any?) {
        print("Starting OSC peer.")
        do {
            let newPeer = OSCPeer(
                host: remoteHost,
                localPort: localPort,
                remotePort: remotePort
            ) { message, timeTag in
                print(message, "with time tag: \(timeTag)")
            }
            oscPeer = newPeer
            try newPeer.start()
            print("Using local port \(newPeer.localPort) and remote port \(newPeer.remotePort) with remote host \(remoteHost).")
        } catch {
            print("Error while starting OSC peer: \(error)")
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
    @IBOutlet var localPortNumber: NSTextField!
    @IBOutlet var remotePortNumber: NSTextField!
    @IBOutlet weak var remoteHost: NSTextField!
    
    @IBAction
    func startOSCPeer(_ sender: Any?) {
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        
        appDelegate?.remoteHost = remoteHost.stringValue
        
        appDelegate?.localPort = !localPortNumber.stringValue.isEmpty
            ? UInt16(localPortNumber.stringValue)
            : nil
        
        appDelegate?.remotePort = !remotePortNumber.stringValue.isEmpty
            ? UInt16(remotePortNumber.stringValue)
            : nil
        
        NSApp.sendAction(
            #selector(AppDelegate.startOSCPeer(_:)),
            to: appDelegate,
            from: self
        )
    }
}
