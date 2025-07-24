//
//  ContentView.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

import OSCKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var oscManager: OSCManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("In this example, port 8000 is opened by the OSC server to listen for incoming OSC packets. The OSC client sends the test message to local port 8000.")
            
            Text("Received OSC messages are logged to the console.")
            
            Button("Send Test OSC Message") {
                sendTestOSCMessage()
            }
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: 480)
    }
    
    private func sendTestOSCMessage() {
        oscManager.send(
            .message("/some/address/method", values: ["Test string", 123]),
            to: "localhost", // destination IP address or host
            port: 8000 // standard OSC port but can be changed
        )
    }
}
