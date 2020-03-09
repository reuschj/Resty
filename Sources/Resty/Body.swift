//
//  Body.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

struct Body: CustomStringConvertible {
    var data: Data?
    var contentType: ContentType?
    init(data: Data, contentType: ContentType? = nil) {
        self.data = data
        self.contentType = contentType
    }
    init?(data: Data?, contentType: ContentType? = nil) {
        guard let data = data else { return nil }
        self.init(data: data, contentType: contentType)
    }
    init(string: String, using encoding: String.Encoding = .utf8, contentType: ContentType = .plain()) {
        self.data = string.data(using: encoding)
        self.contentType = contentType
    }
    init?<T: Encodable>(encodable: T, contentType: ContentType = .json()) {
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
