//
//  Object Access Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@testable import OSCKit
import Testing

/// No functionality tests, just test that API compiles as expected.
@Suite struct Object_Access_Tests {
    @Test func oscClientAccess() async throws {
        let oscClient = OSCClient()
        
        oscClient.isIPv4BroadcastEnabled = true
        oscClient.isIPv4BroadcastEnabled = false
        oscClient.isPortReuseEnabled = true
        oscClient.isPortReuseEnabled = false
        
        let _ = OSCClient(localPort: 8002)
        let _ = OSCClient(localPort: 8003, isPortReuseEnabled: true)
        let _ = OSCClient(localPort: 8004, isPortReuseEnabled: true, isIPv4BroadcastEnabled: true)
        let _ = OSCClient(localPort: 8005, isIPv4BroadcastEnabled: true)
    }
    
    @Test func oscServerAccess() async throws {
        let oscServer = OSCServer()
        
        _ = oscServer.isStarted
        _ = oscServer.localPort
        // oscServer.localPort = 9000 // immutable actor
        oscServer.setHandler { message, timeTag in
            print(message)
        }
        // oscServer.handler = { _,_ in } // immutable actor, use `setHandler()` instead
        
        _ = OSCServer(port: 8006) { message, timeTag in
            print(message)
        }
        _ = OSCServer(port: 8007, timeTagMode: .ignore) { message, timeTag in
            print(message)
        }
    }
    
    @Test func oscSocketAccess() async throws {
        let oscSocket = OSCSocket()
        
        _ = oscSocket.isStarted
        _ = oscSocket.localPort
        // oscSocket.localPort = 9000 // immutable actor
        _ = oscSocket.remoteHost
        // oscSocket.remoteHost = "192.168.0.10" // immutable actor
        _ = oscSocket.remotePort
        // oscSocket.remotePort = 8000 // immutable actor
        _ = oscSocket.isIPv4BroadcastEnabled
        // oscSocket.isIPv4BroadcastEnabled = true // immutable actor
        oscSocket.setHandler { message, timeTag in
            print(message)
        }
        // oscSocket.handler = { _,_ in } // immutable actor, use `setHandler()` instead
        
        _ = OSCSocket(localPort: 8009)
        _ = OSCSocket(localPort: 8010) { message, timeTag in
            print(message)
        }
        _ = OSCSocket(localPort: 8011, timeTagMode: .ignore) { message, timeTag in
            print(message)
        }
        _ = OSCSocket(
            localPort: 8012,
            timeTagMode: .ignore
        ) { message, timeTag in
            print(message)
        }
        _ = OSCSocket(
            localPort: 8013,
            timeTagMode: .ignore,
            isIPv4BroadcastEnabled: true
        ) { message, timeTag in
            print(message)
        }
        _ = OSCSocket(
            localPort: 8014,
            remoteHost: "192.168.0.10",
            remotePort: 8000,
            timeTagMode: .ignore,
            isIPv4BroadcastEnabled: true
        ) { message, timeTag in
            print(message)
        }
    }
}

#endif
