//
//  SocketExampleApp.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import OSCKit

@main
struct SocketExampleApp: App {
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
    
    private let portFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 0
        formatter.maximum = 65535
        formatter.maximumFractionDigits = 0
        formatter.hasThousandSeparators = false
        return formatter
    }()
    let labelColumnWidth: CGFloat = 200
    let controlColumnWidth: CGFloat = 200
    
    var body: some View {
        VStack(spacing: 20) {
            Group {
                Text("The OSCSocket class is designed to send and receive OSC using a single local port.")
                
                Text("Received OSC messages are logged to the console in this example.")
                
                Text("The socket object must be started before messages can be sent or received.")
            }
            .multilineTextAlignment(.center)
            
            GroupBox {
                VStack(spacing: 10) {
                    HStack {
                        Text("Local Port")
                            .frame(width: labelColumnWidth, alignment: .trailing)
                        TextField("", value: $oscManager.localPort, formatter: portFormatter)
                            .frame(width: controlColumnWidth, alignment: .leading)
                    }
                    HStack {
                        Text("Remote Host")
                            .frame(width: labelColumnWidth, alignment: .trailing)
                        TextField("", text: $oscManager.remoteHost)
                            .frame(width: controlColumnWidth, alignment: .leading)
                    }
                    HStack {
                        Text("Remote Port")
                            .frame(width: labelColumnWidth, alignment: .trailing)
                        TextField("", value: $oscManager.remotePort, formatter: portFormatter)
                            .frame(width: controlColumnWidth, alignment: .leading)
                    }
                    
                    HStack {
                        Text("Enable Broadcast")
                            .frame(width: labelColumnWidth, alignment: .trailing)
                        Toggle(isOn: $oscManager.isIPv4BroadcastEnabled) { }
                            .frame(width: controlColumnWidth, alignment: .leading)
                    }
                }
                .padding(10)
            }
            .disabled(oscManager.isStarted)
            
            HStack {
                Button("Start") {
                    Task { await oscManager.start() }
                }
                .disabled(oscManager.isStarted)
                
                Button("Stop") {
                    Task { await oscManager.stop() }
                }
                .disabled(!oscManager.isStarted)
            }
            
            Button("Send Test OSC Message") {
                sendTestOSCMessage()
            }
            .disabled(!oscManager.isStarted)
        }
        .padding()
        .frame(width: 600, height: 450)
    }
    
    private func sendTestOSCMessage() {
        Task {
            await oscManager.send(
                .message("/some/address/method", values: ["Test string", 123])
            )
        }
    }
}
