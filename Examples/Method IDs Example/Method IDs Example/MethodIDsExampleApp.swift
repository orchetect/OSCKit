//
//  MethodIDsExampleApp.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

@main
struct MethodIDsExampleApp: App {
    @StateObject var oscManager = OSCManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(oscManager)
        }
    }
}
