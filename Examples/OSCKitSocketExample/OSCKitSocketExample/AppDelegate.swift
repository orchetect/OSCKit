//
//  AppDelegate.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2023 Steffan Andrews • Licensed under MIT License
//

import Cocoa
import OSCKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var oscSocket: OSCSocket?
    
    var localPort: UInt16?
    var remoteHost: String = ""
    var remotePort: UInt16?
    var isPortReuseEnabled: Bool = false
    var isIPv4BroadcastEnabled: Bool = false
    
    func applicationDidFinishLaunching(_ aNotification: Notification) { }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        oscSocket?.stop()
    }
    
    @IBAction
    func startOSCPeer(_ sender: Any?) {
        print("Starting OSC socket.")
        do {
            let newSocket = OSCSocket(
                localPort: localPort,
                remoteHost: remoteHost,
                remotePort: remotePort
            ) { message, timeTag in
                print(message, "with time tag: \(timeTag)")
            }
            oscSocket = newSocket
            
            newSocket.isPortReuseEnabled = isPortReuseEnabled
            newSocket.isIPv4BroadcastEnabled = isIPv4BroadcastEnabled
            
            try newSocket.start()
            
            print(
                "Using local port \(newSocket.localPort) and remote port \(newSocket.remotePort) with remote host \(remoteHost)."
            )
        } catch {
            print("Error while starting OSC socket: \(error)")
        }
    }
    
    @IBAction
    func stopOSCPeer(_ sender: Any?) {
        print("Stopping OSC socket.")
        oscSocket?.stop()
    }
    
    /// Send a test OSC message.
    @IBAction
    func sendTestOSCMessage(_ sender: Any?) {
        do {
            try oscSocket?.send(
                .message("/conduit/Status", values: ["System"])
            )
        } catch {
            print("Error while sending: \(error)")
        }
    }
}
