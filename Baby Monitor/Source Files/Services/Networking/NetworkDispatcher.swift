//
//  NetworkDispatcher.swift
//  Baby Monitor
//

import Foundation

protocol NetworkDispatcherProtocol: AnyObject {
    func execute(urlRequest: URLRequest, completion: @escaping ((Result<Data>) -> Void))
    func executeWithJsonParsing<T: Decodable>(urlRequest: URLRequest, completion: ((Result<T>) -> Void)?)
}

final class NetworkDispatcher: NSObject, NetworkDispatcherProtocol {
    
    private let urlSession: URLSessionProtocol
    private let dispatchQueue: DispatchQueue
    
    init(urlSession: URLSessionProtocol, dispatchQueue: DispatchQueue) {
        self.urlSession = urlSession
        self.dispatchQueue = dispatchQueue
        super.init()
    }
    
    func execute(urlRequest: URLRequest, completion: @escaping ((Result<Data>) -> Void)) {
        let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
            var result = Result<Data>.failure(nil)
            if let error = error {
                result = .failure(error)
            } else if let data = data {
                result = .success(data)
            }
            completion(result)
        }
        dispatchQueue.async {
            dataTask.resume()
        }
    }
    
    func executeWithJsonParsing<T: Decodable>(urlRequest: URLRequest, completion: ((Result<T>) -> Void)?) {
        execute(urlRequest: urlRequest) { result in
            completion?(result.map { try JSONDecoder().decode(T.self, from: $0) })
        }
    }
}
