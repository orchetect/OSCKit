//
//  BasicExampleApp.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OSCKit

@main
struct BasicExampleApp: App {
    @StateObject var oscManager = OSCManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(oscManager)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var oscManager: OSCManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("By default, port 8000 is opened to listen for incoming OSC data. Port 8000 is used to send the test message.")
            
            Text("Received OSC messages are logged to the console.")
            
            Button("Send Test OSC Message") {
                sendTestOSCMessage()
            }
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(width: 480, height: 200)
    }
    
    private func sendTestOSCMessage() {
        oscManager.send(
            .message("/some/address/method", values: ["Test string", 123]),
            to: "localhost", // destination IP address or hostname
            port: 8000 // standard OSC port but can be changed
        )
    }
}
