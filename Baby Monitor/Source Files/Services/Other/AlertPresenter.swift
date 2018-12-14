//
//  AlertPresenter.swift
//  Baby Monitor
//

import UIKit

struct AlertPresenter {
    
    private init() {}
    
    static func showDefaultAlert(title: String?, message: String?, onViewController vc: UIViewController) {
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(alertAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
