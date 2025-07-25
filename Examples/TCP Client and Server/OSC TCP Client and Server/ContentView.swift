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
            Group {
                Text("Received OSC messages are logged to the console.")
            }
            .multilineTextAlignment(.center)
            
            #if !os(tvOS)
            GroupBox { configurationView }
            #else
            configurationView
            #endif
        }
        .padding()
        .frame(maxWidth: 400)
    }
    
    @ViewBuilder
    private var configurationView: some View {
        VStack(spacing: 10) {
            RowView(label: "TCP Framing") {
                Picker("", selection: $oscManager.framingMode) {
                    ForEach(OSCTCPFramingMode.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
                .labelsHidden()
            }
            .disabled(oscManager.isServerStarted || oscManager.isClientConnected)
            
            RowView(label: "") {
                Text(oscManager.framingMode.protocolName)
            }
            
            Divider()
            
            RowView(label: "Server Port") {
                TextField("", value: $oscManager.serverPort, formatter: .networkPort)
                #if !os(macOS)
                    .keyboardType(.decimalPad)
                #endif
            }
            .disabled(oscManager.isServerStarted)
            
            RowView(label: "") {
                Button("Start") {
                    oscManager.startServer()
                }
                .disabled(oscManager.isServerStarted)
            }
            
            RowView(label: "") {
                Button("Stop") {
                    oscManager.stopServer()
                }
                .disabled(!oscManager.isServerStarted)
            }
            
            Button("Send Test OSC Message") {
                sendTestOSCMessageToAllClients()
            }
            .disabled(!oscManager.isServerStarted)
            
            Divider()
            
            Group {
                RowView(label: "Client Host") {
                    TextField("", text: $oscManager.clientHost)
                }
                
                RowView(label: "Client Port") {
                    TextField("", value: $oscManager.clientPort, formatter: .networkPort)
                    #if !os(macOS)
                        .keyboardType(.decimalPad)
                    #endif
                }
            }
            .disabled(oscManager.isClientConnected)
            
            RowView(label: "") {
                Button("Connect") {
                    oscManager.connectClient()
                }
                .disabled(oscManager.isClientConnected)
            }
            
            RowView(label: "") {
                Button("Disconnect") {
                    oscManager.disconnectClient()
                }
                .disabled(!oscManager.isClientConnected)
            }
            
            RowView(label: "") {
                Button("Send Test OSC Message") {
                    sendTestOSCMessageToServer()
                }
                .disabled(!oscManager.isClientConnected)
            }
        }
        .padding(10)
    }
    
    private func sendTestOSCMessageToServer() {
        oscManager.sendToServer(
            .message("/some/address/method", values: ["Test string", 123])
        )
    }
    
    private func sendTestOSCMessageToAllClients() {
        oscManager.sendToAllClients(
            .message("/some/address/method", values: ["Test string", 123])
        )
    }
}

struct RowView<Content: View>: View {
    var label: String
    @ViewBuilder var content: () -> Content
    
    private let labelColumnWidth: CGFloat = 150
    private let controlColumnWidth: CGFloat = 250
    
    var body: some View {
        HStack(spacing: 20) {
            Text(label)
            Spacer()
            VStack(alignment: .trailing) {
                content()
                    .multilineTextAlignment(.trailing)
            }
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

extension OSCTCPFramingMode {
    var name: String {
        switch self {
        case .osc1_0: "OSC 1.0"
        case .osc1_1: "OSC 1.1"
        case .none: "None"
        }
    }
    
    var protocolName: String {
        switch self {
        case .osc1_0: "Packet Length Header"
        case .osc1_1: "SLIP"
        case .none: "No framing"
        }
    }
}
