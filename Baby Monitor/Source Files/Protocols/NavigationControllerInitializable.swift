//
//  NavigationControllerInitializable.swift
//  Baby Monitor
//


import UIKit

protocol NavigationControllerInitializable: class {
    
    var navigationController: UINavigationController { get set }
    
    init(_ navigationController: UINavigationController)
}
