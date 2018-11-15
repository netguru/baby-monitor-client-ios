//
//  String+JSON.swift
//  Baby Monitor
//

extension String {
    
    var jsonDictionary: [String: [AnyHashable: Any]]? {
        guard let data = data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
        let jsonDictionary = jsonObject as? [String: [AnyHashable: Any]] else {
                return nil
        }
        return jsonDictionary
    }
}
