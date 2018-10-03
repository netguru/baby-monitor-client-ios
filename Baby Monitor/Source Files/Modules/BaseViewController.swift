//
//  BaseViewController.swift
//  Baby Monitor
//


import UIKit

/// This class should be used in case of creating new view controller class.
/// For now it is only for not writing `required init?(coder aDecoder: NSCoder)`.
/// In the future it will probably have more features.
class BaseViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
