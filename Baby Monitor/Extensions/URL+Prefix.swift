//
//  URL+RTSP.swift
//  Baby Monitor
//

extension URL {
    
    /// Returns prefixed url
    ///
    /// - Parameter ip: Server ip
    /// - Parameter port: Server port
    /// - Parameter prefix: Protocol prefix
    /// - Returns: URL with formatted path with given ip and port
    static func with(ip: String, port: String, prefix: String) -> URL? {
        return URL(string: "\(prefix)://\(ip):\(port)")
    }
}
