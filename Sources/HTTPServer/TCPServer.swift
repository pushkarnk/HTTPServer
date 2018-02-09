import Foundation
import Glibc

struct TCPServer {
    let appProtocol: ApplicationProtocol
    let listenFD: Int32

    public init(for protocol: ApplicationProtocol) {
        self.appProtocol = `protocol`
        var on = 1
        let socketAddress = UnsafeMutablePointer<sockaddr_in>.allocate(capacity: 1)
        listenFD = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
        let sa = sockaddr_in(sin_family: sa_family_t(AF_INET), sin_port: htons(35191),
                             sin_addr: in_addr(s_addr: UInt32(INADDR_LOOPBACK).bigEndian), sin_zero: (0,0,0,0,0,0,0,0))
        socketAddress.initialize(to: sa)
        setsockopt(listenFD, SOL_SOCKET, SO_REUSEADDR, &on, socklen_t(MemoryLayout<Int>.size))
            socketAddress.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size, {
            _ = bind(listenFD, UnsafePointer<sockaddr>($0), socklen_t(MemoryLayout<sockaddr>.size))
        })

        listen(listenFD, 100)
    }

    public func run() {
        var maxFD = listenFD
        var clients = [Int32]()
        var allSet = fd_set()

        FD_SET(listenFD, &allSet)

        while true {
            var readSet = allSet
            var nready = Int(select(maxFD + 1, &readSet, nil, nil, nil))

            if FD_ISSET(listenFD, &readSet) {
                var sockLen = socklen_t(MemoryLayout<sockaddr>.size)
                let connectionFD = accept(listenFD, UnsafeMutablePointer<sockaddr>.allocate(capacity: 1), &sockLen)
                clients.append(connectionFD)
                FD_SET(connectionFD, &allSet)
                maxFD = connectionFD > maxFD ? connectionFD : maxFD
                nready -= 1
            }

            guard nready > 0 else { continue }

            for idx in 0..<clients.count {
                guard nready > 0 else { continue }
                var buffer = [UInt8](repeating: 0, count: 4096)
                if FD_ISSET(clients[idx], &readSet) {
                    _ = read(clients[idx], &buffer, 4096)
                    let responses = appProtocol.process(String(cString: buffer))
                    for line in responses {
                        let response = Array(line.utf8) 
                        print(response)
                        let n = write(clients[idx], response, response.count)
                        print("Wrote \(n) bytes")
                    }
                    close(clients[idx])
                    FD_CLR(clients[idx], &allSet)
                    clients.remove(at: idx)
                    nready -= 1
                }
            }
        }    
    }
}
