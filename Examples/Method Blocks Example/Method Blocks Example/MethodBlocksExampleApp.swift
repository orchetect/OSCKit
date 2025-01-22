//
//  MethodBlocksExampleApp.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@main
struct MethodBlocksExampleApp: App {
    @StateObject var oscManager = OSCManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(oscManager)
        }
    }
}
