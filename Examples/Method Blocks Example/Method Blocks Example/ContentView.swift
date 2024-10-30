//
//  ContentView.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OSCKit

struct ContentView: View {
    @EnvironmentObject private var oscManager: OSCManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("By default, port 8000 is opened to listen for incoming OSC data. Port 8000 is used to send the test message.")
            
            Text("Received OSC messages are logged to the console.")
            
            Button("Send Test OSC Message A") {
                sendTestOSCMessageA()
            }
            
            Button("Send Test OSC Message B") {
                sendTestOSCMessageB()
            }
            
            Button("Send Test OSC Message C With Optional Value") {
                sendTestOSCMessageCWithOptionalValue()
            }
            
            Button("Send Test OSC Message C With No Optional Value") {
                sendTestOSCMessageCWithNoOptionalValue()
            }
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: 480)
    }
    
    private func sendTestOSCMessageA() {
        let oscMessage = OSCMessage(
            "/methodA",
            values: ["Test string"]
        )
        
        oscManager.send(oscMessage, to: "localhost", port: 8000)
    }
    
    private func sendTestOSCMessageB() {
        let oscMessage = OSCMessage(
            "/some/address/methodB",
            values: ["Test string", 123]
        )
        
        oscManager.send(oscMessage, to: "localhost", port: 8000)
    }
    
    private func sendTestOSCMessageCWithOptionalValue() {
        let oscMessage = OSCMessage(
            "/some/address/methodC",
            values: ["Test string", 123.5]
        )
        
        oscManager.send(oscMessage, to: "localhost", port: 8000)
    }
    private func sendTestOSCMessageCWithNoOptionalValue() {
        let oscMessage = OSCMessage(
            "/some/address/methodC",
            values: ["Test string"]
        )
        
        oscManager.send(oscMessage, to: "localhost", port: 8000)
    }
}
