//
//  Dictionary+JSON.swift
//  Baby Monitor
//

extension Dictionary where Key == String, Value == [AnyHashable: Any] {
    var jsonString: String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }

}
