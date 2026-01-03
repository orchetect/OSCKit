//
//  Object Access Tests.swift
//  OSCKit • https://github.com/orchetect/OSCKit
//  © 2020-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(watchOS)

@testable import OSCKit
import Testing

/// No functionality tests, just test that API compiles as expected.
@Suite struct Object_Access_Tests {
    @Test
    func oscClientAccess() async throws {
        let oscClient = OSCUDPClient()
        
        oscClient.isIPv4BroadcastEnabled = true
        oscClient.isIPv4BroadcastEnabled = false
        oscClient.isPortReuseEnabled = true
        oscClient.isPortReuseEnabled = false
        
        _ = OSCUDPClient(localPort: 8002)
        _ = OSCUDPClient(localPort: 8003, isPortReuseEnabled: true)
        _ = OSCUDPClient(localPort: 8004, isPortReuseEnabled: true, isIPv4BroadcastEnabled: true)
        _ = OSCUDPClient(localPort: 8005, isIPv4BroadcastEnabled: true)
    }
    
    @Test
    func oscServerAccess() async throws {
        let oscServer = OSCUDPServer()
        
        _ = oscServer.isStarted
        _ = oscServer.localPort
        // oscServer.localPort = 9000 // immutable actor
        oscServer.isPortReuseEnabled = true
        oscServer.isPortReuseEnabled = false
        oscServer.setReceiveHandler { message, timeTag, host, port in
            print(message)
        }
        // oscServer.receiveHandler = { _,_ in } // immutable actor, use `setReceiveHandler()` instead
        
        _ = OSCUDPServer(port: 8006) { message, timeTag, host, port in
            print(message)
        }
        _ = OSCUDPServer(port: 8007, timeTagMode: .ignore) { message, timeTag, host, port in
            print(message)
        }
    }
    
    @Test
    func oscSocketAccess() async throws {
        let oscSocket = OSCUDPSocket()
        
        _ = oscSocket.isStarted
        _ = oscSocket.localPort
        // oscSocket.localPort = 9000 // immutable actor
        _ = oscSocket.remoteHost
        // oscSocket.remoteHost = "192.168.0.10" // immutable actor
        _ = oscSocket.remotePort
        // oscSocket.remotePort = 8000 // immutable actor
        _ = oscSocket.isIPv4BroadcastEnabled
        // oscSocket.isIPv4BroadcastEnabled = true // immutable actor
        oscSocket.setReceiveHandler { message, timeTag, host, port in
            print(message)
        }
        // oscSocket.receiveHandler = { _,_ in } // immutable actor, use `setReceiveHandler()` instead
        
        _ = OSCUDPSocket(localPort: 8009)
        _ = OSCUDPSocket(localPort: 8010) { message, timeTag, host, port in
            print(message)
        }
        _ = OSCUDPSocket(localPort: 8011, timeTagMode: .ignore) { message, timeTag, host, port in
            print(message)
        }
        _ = OSCUDPSocket(
            localPort: 8012,
            timeTagMode: .ignore
        ) { message, timeTag, host, port in
            print(message)
        }
        _ = OSCUDPSocket(
            localPort: 8013,
            timeTagMode: .ignore,
            isIPv4BroadcastEnabled: true
        ) { message, timeTag, host, port in
            print(message)
        }
        _ = OSCUDPSocket(
            localPort: 8014,
            remoteHost: "192.168.0.10",
            remotePort: 8000,
            timeTagMode: .ignore,
            isIPv4BroadcastEnabled: true
        ) { message, timeTag, host, port in
            print(message)
        }
    }
}

#endif
