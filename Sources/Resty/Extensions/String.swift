//
//  String.swift
//  Resty
//
//  Created by Justin Reusch on 3/29/20.
//

import Foundation

public extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String { Data(self.utf8).base64EncodedString() }
}
