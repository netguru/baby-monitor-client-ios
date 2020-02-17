//
//  FirebasePushNotificationsRequest.swift
//  Baby Monitor
//

import Foundation

final class FirebasePushNotificationsRequest: Request, URLRequestConvertible {

    private let mode: SoundDetectionMode

    init(receiverId: String, serverKey: String, mode: SoundDetectionMode) {
        self.mode = mode
        headers?["Authorization"] = "key=\(serverKey)"
        body?["to"] = receiverId
    }
    
    var headers: [String: String]? = [
        "Content-Type": "application/json"
    ]

    lazy var body: [String: Any]? = {
        let title = Localizable.General.attention
        let body: String
        switch mode {
        case .cryRecognition:
            body = Localizable.Server.babyIsCrying
        case .noiseDetection:
            body = Localizable.Server.noiseDetected
        }
        return ["notification": ["title": title, "body": body]]
    }()

    let basePath = "https://fcm.googleapis.com"
    let apiPath = ""
    let path = "/fcm/send"
    let method: HTTPMethod = .post
    let parameters: [String: String]? = nil
}
