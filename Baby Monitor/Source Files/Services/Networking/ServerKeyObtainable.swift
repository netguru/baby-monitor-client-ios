//
//  ServerKeyObtainable.swift
//  Baby Monitor
//

import Foundation
import Keys

protocol ServerKeyObtainableProtocol: AnyObject {
    var serverKey: String { get }
}

final class ServerKeyObtainable: ServerKeyObtainableProtocol {
    let serverKey = EidolonKeys().firebaseServerKey
}
