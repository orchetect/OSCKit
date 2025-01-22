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
            Group {
                Text("The OSCSocket class is designed to send and receive OSC using a single local port.")
                
                Text("Received OSC messages are logged to the console in this example.")
                
                Text("The socket object must be started before messages can be sent or received.")
            }
            .multilineTextAlignment(.center)
            
            #if !os(tvOS)
            GroupBox { configurationView }
            #else
            configurationView
            #endif
            
            Button("Send Test OSC Message") {
                sendTestOSCMessage()
            }
            .disabled(!oscManager.isStarted)
        }
        .padding()
        .frame(maxWidth: 600)
    }
    
    @ViewBuilder
    private var configurationView: some View {
        VStack(spacing: 10) {
            Group {
                RowView(label: "Local Port") {
                    TextField("", value: $oscManager.localPort, formatter: .networkPort)
                        #if !os(macOS)
                        .keyboardType(.decimalPad)
                        #endif
                }
                
                RowView(label: "Remote Host") {
                    TextField("", text: $oscManager.remoteHost)
                }
                
                RowView(label: "Remote Port") {
                    TextField("", value: $oscManager.remotePort, formatter: .networkPort)
                        #if !os(macOS)
                        .keyboardType(.decimalPad)
                        #endif
                }
                
                RowView(label: "Enable Broadcast") {
                    Toggle(isOn: $oscManager.isIPv4BroadcastEnabled) { }
                        .labelsHidden()
                }
            }
            .disabled(oscManager.isStarted)
            
            RowView(label: "Start Socket") {
                Button("Start") {
                    oscManager.start()
                }
                .disabled(oscManager.isStarted)
            }
            
            RowView(label: "Stop Socket") {
                Button("Stop") {
                    oscManager.stop()
                }
                .disabled(!oscManager.isStarted)
            }
        }
        .padding(10)
    }
    
    private func sendTestOSCMessage() {
        oscManager.send(
            .message("/some/address/method", values: ["Test string", 123])
        )
    }
}

struct RowView<Content: View>: View {
    var label: String
    @ViewBuilder var content: () -> Content
    
    private let labelColumnWidth: CGFloat = 200
    private let controlColumnWidth: CGFloat = 200
    
    var body: some View {
        HStack(spacing: 20) {
            Text(label)
                .frame(maxWidth: labelColumnWidth, alignment: .trailing)
            content()
                .frame(maxWidth: controlColumnWidth, alignment: .leading)
        }
    }
}

extension Formatter {
    static let networkPort: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimum = 0
        formatter.maximum = 65535
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        return formatter
    }()
}
