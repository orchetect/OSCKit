//
//  OSCUDPSocketApp.swift
//  SwiftOSC I/O: Cocoa • https://github.com/orchetect/swift-osc-io-cocoa
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftOSCIOCocoa
import SwiftUI

@main
struct OSCUDPSocketApp: App {
    @StateObject var oscManager = OSCManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(oscManager)
        }
    }
}
