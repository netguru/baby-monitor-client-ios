//
//  ClearableLazyItem.swift
//  Baby Monitor
//

import Foundation

final class ClearableLazyItem<T> {
    private var t: T!
    
    private let constructor: () -> T
    
    init(constructor: @escaping () -> T) {
        self.constructor = constructor
    }
    
    func get() -> T {
        if t == nil {
            t = constructor()
        }
        return t
    }
    
    func clear() {
        t = nil
    }
    
    var isCleared: Bool {
        return t == nil
    }
}
