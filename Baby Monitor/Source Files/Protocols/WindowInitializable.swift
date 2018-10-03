//
//  WindowInitializable.swift
//  Baby Monitor
//


import UIKit

protocol WindowInitializable: class {
    
    var window: UIWindow { get set }
    
    init(_ window: UIWindow)
}
