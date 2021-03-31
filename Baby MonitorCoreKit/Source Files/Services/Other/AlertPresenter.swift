//
//  AlertPresenter.swift
//  Baby Monitor
//

import UIKit

struct AlertPresenter {
    
    private init() {}
    
    static func showDefaultAlert(title: String?, message: String?, onViewController vc: UIViewController, customActions: [(String, UIAlertAction.Style, (() -> Void)?)] = []) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            var actionsToAdd: [UIAlertAction] = []
            if !customActions.isEmpty {
                customActions.forEach {
                    let alertTitle = $0.0
                    let alertStyle = $0.1
                    if let alertHandler = $0.2 {
                        let alertAction = UIAlertAction(title: alertTitle, style: alertStyle, handler: { _ in
                            alertHandler()
                        })
                        actionsToAdd.append(alertAction)
                    } else {
                        let alertAction = UIAlertAction(title: alertTitle, style: alertStyle, handler: nil)
                        actionsToAdd.append(alertAction)
                    }
                }
            } else {
                let alertAction = UIAlertAction(title: Localizable.General.ok, style: .default, handler: nil)
                actionsToAdd.append(alertAction)
            }
            actionsToAdd.forEach {
                alertController.addAction($0)
            }
            vc.present(alertController, animated: true, completion: nil)
        }
    }
}
