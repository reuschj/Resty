//
//  Body.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

struct Body: CustomStringConvertible {
    var data: Data?
    var contentType: String?
    init(data: Data, contentType: String? = nil) {
        self.data = data
        self.contentType = contentType
    }
    init(data: Data, contentType: ContentType) {
        self.init(data: data, contentType: contentType.description)
    }
    init?(data: Data?, contentType: String? = nil) {
        guard let data = data else { return nil }
        self.init(data: data, contentType: contentType)
    }
    init?(data: Data?, contentType: ContentType) {
        guard let data = data else { return nil }
        self.init(data: data, contentType: contentType)
    }
    init(string: String, using encoding: String.Encoding = .utf8, contentType: String = ContentType.plain.description) {
        self.data = string.data(using: encoding)
        self.contentType = contentType
    }
    init?<T: Encodable>(encodable: T, contentType: String = ContentType.json.description) {
        do {
            self.data = try JSONEncoder().encode(encodable)
            self.contentType = contentType
        } catch {
            print(String(describing: error))
            return nil
        }
    }
    func toString(using encoding: String.Encoding = .utf8) -> String {
        if let data = self.data {
            return String(data: data, encoding: encoding) ?? ""
        } else {
            return ""
        }
    }
    var description: String { self.toString(using: .utf8) }
}
