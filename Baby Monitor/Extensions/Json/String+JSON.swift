//
//  String+JSON.swift
//  Baby Monitor
//

extension String {
    
    var jsonDictionary: [String: [AnyHashable: Any]]? {
        guard let data = data(using: .utf8),
            let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else {
                return nil
        }
        return jsonObject as? [String: [AnyHashable: Any]]
    }
}
