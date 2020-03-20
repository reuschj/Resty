//
//  Body.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

/// Wrapper for body `Data`, which takes input from other types and converts to `Data` type.
/// Optionally, holds a content type
public struct Body: CustomStringConvertible {
    /// Data
    public var data: Data?
    public var contentType: ContentType?
    
    public init(data: Data, contentType: ContentType? = nil) {
        self.data = data
        self.contentType = contentType
    }
    
    public init?(data: Data?, contentType: ContentType? = nil) {
        guard let data = data else { return nil }
        self.init(data: data, contentType: contentType)
    }
    
    public init(string: String, using encoding: String.Encoding = .utf8, contentType: ContentType = .plain()) {
        self.data = string.data(using: encoding)
        self.contentType = contentType
    }
    
//    public init?(dictionary: Dictionary[String:Any] = [:], contentType: ContentType? = .json()) {
//        do {
//            self.data = try JSONEncoder().encode(dictionary)
//            self.contentType = contentType
//        } catch {
//            print(String(describing: error))
//            return nil
//        }
//    }
    
    public init?<T: Encodable>(encodable: T, contentType: ContentType = .json()) {
        do {
            self.data = try JSONEncoder().encode(encodable)
            self.contentType = contentType
        } catch {
            print(String(describing: error))
            return nil
        }
    }
    
    public func getDescription(using encoding: String.Encoding = .utf8) -> String {
        if let data = self.data {
            return String(data: data, encoding: encoding) ?? ""
        } else {
            return ""
        }
    }
    
    public var description: String { self.getDescription(using: .utf8) }
}
