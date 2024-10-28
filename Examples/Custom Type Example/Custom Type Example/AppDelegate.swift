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
        Task {
            do {
                try await OSCSerialization.shared.registerType(CustomType.self)
            } catch {
                print(error.localizedDescription)
            }
            
            await oscManager.start()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        Task { await oscManager.stop() }
    }
}

extension AppDelegate {
    /// Send a test OSC message.
    @IBAction
    func sendTestOSCMessage(_ sender: Any) {
        let customType = CustomType(id: Int.random(in: 0...9), name: UUID().uuidString)
        oscManager.send(
            .message("/test", values: [customType]),
            to: "localhost", // destination IP address or hostname
            port: 8000 // standard OSC port but can be changed
        )
    }
}
