//
//  Request.swift
//  Baby Monitor
//

import Foundation

protocol Request {
    var basePath: String { get }
    var apiPath: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: [String: Any]? { get }
    var parameters: [String: String]? { get }
    var headers: [String: String]? { get }
}
