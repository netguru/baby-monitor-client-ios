//
//  ErrorHandler.swift
//  Baby Monitor
//

import UIKit

protocol ErrorHandlerProtocol {
    
    /// Shows an alert with details of an error
    ///
    /// - Parameter title: General title for the alert
    /// - Parameter message: Main text with error details
    /// - Parameter presenter: A view controller which is responsible for presenting the alert
    /// - Parameter secondAction: An additional alert action for the alert, except the default OK action
    func showAlert(title: String, message: String, presenter: UIViewController?, secondAction: UIAlertAction?)
}

final class ErrorHandler: ErrorHandlerProtocol {
    
    func showAlert(title: String, message: String, presenter: UIViewController?, secondAction: UIAlertAction?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Localizable.General.ok, style: .default, handler: nil)
        alert.addAction(okAction)
        if let secondAction = secondAction {
            alert.addAction(secondAction)
        }
        
        presenter?.present(alert, animated: true, completion: nil)
    }
}
