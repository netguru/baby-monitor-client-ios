//
//  NetworkDispatcher.swift
//  Baby Monitor
//

import Foundation

protocol NetworkDispatcherProtocol: AnyObject {
    func execute(urlRequest: URLRequest, completion: ((Result<Data>) -> Void)?)
    func execute<T: Decodable>(urlRequest: URLRequest, completion: ((Result<T>) -> Void)?)
}

final class NetworkDispatcher: NSObject, NetworkDispatcherProtocol {
    
    private lazy var defaultUrlSession = URLSession(configuration: .default)
    private let dispatchQueue = DispatchQueue(label: "NetworkDispatcherQueue")
    
    func execute(urlRequest: URLRequest, completion: ((Result<Data>) -> Void)?) {
        let dataTask = defaultUrlSession.dataTask(with: urlRequest) { data, response, error in
            var result = Result<Data>.failure(nil)
            if let error = error {
                result = .failure(error)
            } else if let data = data {
                result = .success(data)
                
            }
            completion?(result)
        }
        dispatchQueue.async {
            dataTask.resume()
        }
    }
    
    func execute<T: Decodable>(urlRequest: URLRequest, completion: ((Result<T>) -> Void)?) {
        execute(urlRequest: urlRequest) { result in
            let newResult: Result<T>
            switch result {
            case .success(let data):
                do {
                    let decodable = try JSONDecoder().decode(T.self, from: data)
                    newResult = .success(decodable)
                } catch {
                    newResult = .failure(error)
                }
            case .failure(let error):
                newResult = .failure(error)
            }
            completion?(newResult)
        }
    }
}
