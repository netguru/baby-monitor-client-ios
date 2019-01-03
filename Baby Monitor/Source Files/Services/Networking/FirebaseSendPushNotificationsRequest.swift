//
//  FirebasePushNotificationsRequest.swift
//  Baby Monitor
//

import Foundation

struct FirebasePushNotificationsRequest: Request, URLRequestConvertible {
    
    init(receiverId: String, serverKey: String) {
        headers?["Authorization"] = "key=\(serverKey)"
        body?["to"] = receiverId
    }
    
    var basePath = "https://fcm.googleapis.com"
    var apiPath = ""
    var path = "/fcm/send"
    var method: HTTPMethod = .post
    var parameters: [String: String]?
    var headers: [String: String]? = [
        "Content-Type": "application/json"
    ]
    var body: [String: Any]? = [
        "notification": [
            "title": Localizable.General.attention,
            "body": Localizable.Server.babyIsCrying
        ]
    ]
}
