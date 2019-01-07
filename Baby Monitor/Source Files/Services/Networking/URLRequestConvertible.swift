//
//  URLRequestConvertible.swift
//  Baby Monitor
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() -> URLRequest
}

extension URLRequestConvertible where Self: Request {
    
    func asURLRequest() -> URLRequest {
        var urlString = basePath
            .appending(apiPath)
            .appending(path)
        
        if let parameters = parameters, !parameters.isEmpty {
            urlString.append("?")
            parameters.forEach {
                urlString.append("/\($0.key)=\($0.value)")
            }
        }
        guard let url = URL(string: urlString) else {
            fatalError("Could not initialize URL with path: \(urlString)")
        }
        var urlRequest = URLRequest(url: url)
        if let body = body {
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                urlRequest.httpBody = data
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
