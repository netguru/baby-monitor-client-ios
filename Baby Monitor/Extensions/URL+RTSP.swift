//
//  URL+RTSP.swift
//  Baby Monitor
//

extension URL {
    
    /// Returns rtsp url
    ///
    /// - Parameter fromIp: Server ip
    /// - Parameter andPort: Server port
    /// - Returns: URL with rtsp formatted path with given ip and port
    static func rtsp(ip: String, port: String) -> URL? {
        return URL(string: "rtsp://\(ip):\(port)")
    }
}
