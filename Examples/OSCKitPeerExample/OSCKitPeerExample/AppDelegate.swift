//
//  AppDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var oscPeer: OSCSocket?
    var localPort: UInt16?
    var remoteHost: String = ""
    var remotePort: UInt16?
    var isPortReuseEnabled: Bool = false
    var isIPv4BroadcastEnabled: Bool = false
    
    func applicationDidFinishLaunching(_ aNotification: Notification) { }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscPeer?.stop()
    }
    
    @IBAction
    func startOSCPeer(_ sender: Any?) {
        print("Starting OSC socket.")
        do {
            let newPeer = OSCSocket(
                localPort: localPort,
                remoteHost: remoteHost,
                remotePort: remotePort
            ) { message, timeTag in
                print(message, "with time tag: \(timeTag)")
            }
            oscPeer = newPeer
            
            newPeer.isPortReuseEnabled = isPortReuseEnabled
            newPeer.isIPv4BroadcastEnabled = isIPv4BroadcastEnabled
            
            try newPeer.start()
            print("Using local port \(newPeer.localPort) and remote port \(newPeer.remotePort) with remote host \(remoteHost).")
        } catch {
            print("Error while starting OSC socket: \(error)")
        }
    }
    
    @IBAction
    func stopOSCPeer(_ sender: Any?) {
        print("Stopping OSC socket.")
        oscPeer?.stop()
    }
    
    /// Send a test OSC message.
    @IBAction
    func sendTestOSCMessage(_ sender: Any?) {
        do {
            try oscPeer?.send(
                .message("/conduit/Status", values: ["System"])
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
    @IBOutlet weak var enablePortReuse: NSButton!
    @IBOutlet weak var enableBroadcast: NSButton!
    
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    
    @IBOutlet weak var sendOSCMessageButton: NSButton!
    
    @IBAction
    func startOSCPeer(_ sender: Any?) {
        // update AppDelegate properties
        
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        
        appDelegate?.remoteHost = remoteHost.stringValue
        
        appDelegate?.localPort = !localPortNumber.stringValue.isEmpty
            ? UInt16(localPortNumber.stringValue)
            : nil
        
        appDelegate?.remotePort = !remotePortNumber.stringValue.isEmpty
            ? UInt16(remotePortNumber.stringValue)
            : nil
        
        appDelegate?.isPortReuseEnabled = enablePortReuse.state == .on
        
        appDelegate?.isIPv4BroadcastEnabled = enableBroadcast.state == .on
        
        // update local UI
        
        localPortNumber.isEnabled = false
        remotePortNumber.isEnabled = false
        remoteHost.isEnabled = false
        enablePortReuse.isEnabled = false
        enableBroadcast.isEnabled = false
        startButton.isEnabled = false
        stopButton.isEnabled = true
        sendOSCMessageButton.isEnabled = true
        
        // push responder event to AppDelegate
        
        NSApp.sendAction(
            #selector(AppDelegate.startOSCPeer(_:)),
            to: appDelegate,
            from: self
        )
    }
    
    @IBAction
    func stopOSCPeer(_ sender: Any?) {
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        
        // update local UI
        
        localPortNumber.isEnabled = true
        remotePortNumber.isEnabled = true
        remoteHost.isEnabled = true
        enablePortReuse.isEnabled = true
        enableBroadcast.isEnabled = true
        startButton.isEnabled = true
        stopButton.isEnabled = false
        sendOSCMessageButton.isEnabled = false
        
        // push responder event to AppDelegate
        
        NSApp.sendAction(
            #selector(AppDelegate.stopOSCPeer(_:)),
            to: appDelegate,
            from: self
        )
    }
}
