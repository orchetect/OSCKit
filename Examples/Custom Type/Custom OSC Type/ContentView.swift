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
            Text("By default, port 8000 is opened to listen for incoming OSC data. Port 8000 is used to send the test message.")
            
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
        let customType = CustomType(id: Int.random(in: 0 ... 9), name: UUID().uuidString)
        
        oscManager.send(
            .message("/test", values: [customType]),
            to: "localhost", // destination IP address or host
            port: 8000 // standard OSC port but can be changed
        )
    }
}
