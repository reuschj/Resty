//
//  BodyParameters.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

struct BodyParameters: KeyValueMap {
    var values: [String : String] = [:]
    init(with values: [String : String] = [:]) {
        self.values = values
    }
}
