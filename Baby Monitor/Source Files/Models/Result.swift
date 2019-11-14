//
//  Result.swift
//  Baby Monitor
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error?)
    
    func map<G>(f: (T) throws -> (G)) -> Result<G> {
        switch self {
        case .success(let value):
            do {
                return .success(try f(value))
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
