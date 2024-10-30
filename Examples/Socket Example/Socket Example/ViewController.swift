//
//  ViewController.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var localPortNumber: NSTextField!
    @IBOutlet var remotePortNumber: NSTextField!
    @IBOutlet var remoteHost: NSTextField!
    @IBOutlet var enableBroadcast: NSButton!
    
    @IBOutlet var startButton: NSButton!
    @IBOutlet var stopButton: NSButton!
    
    @IBOutlet var sendOSCMessageButton: NSButton!
    
    @IBAction
    func startOSCPeer(_ sender: Any?) {
        // update AppDelegate properties
        
        let appDelegate = NSApplication.shared.delegate as? AppDelegate
        let oscManager = appDelegate?.oscManager
        
        Task {
            oscManager?.remoteHost = remoteHost.stringValue
            
            oscManager?.localPort = !localPortNumber.stringValue.isEmpty
                ? UInt16(localPortNumber.stringValue)
                : nil
            
            oscManager?.remotePort = !remotePortNumber.stringValue.isEmpty
                ? UInt16(remotePortNumber.stringValue)
                : nil
            
            oscManager?.isIPv4BroadcastEnabled = enableBroadcast.state == .on
        }
        
        // update local UI
        
        localPortNumber.isEnabled = false
        remotePortNumber.isEnabled = false
        remoteHost.isEnabled = false
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
