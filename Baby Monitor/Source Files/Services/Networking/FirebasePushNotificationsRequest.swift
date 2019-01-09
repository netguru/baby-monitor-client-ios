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
    
    var headers: [String: String]? = [
        "Content-Type": "application/json"
    ]
    var body: [String: Any]? = [
        "notification": [
            "title": Localizable.General.attention,
            "body": Localizable.Server.babyIsCrying
        ]
    ]
    let basePath = "https://fcm.googleapis.com"
    let apiPath = ""
    let path = "/fcm/send"
    let method: HTTPMethod = .post
    let parameters: [String: String]? = nil
}
