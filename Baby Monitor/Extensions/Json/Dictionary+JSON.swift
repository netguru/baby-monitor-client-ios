//
//  Dictionary+JSON.swift
//  Baby Monitor
//

extension Dictionary where Key == String, Value == [AnyHashable: Any] {
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .utf8) else {
                return nil
        }
        return jsonString
    }
    
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
    }
}
