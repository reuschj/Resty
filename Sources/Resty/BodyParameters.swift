//
//  BodyParameters.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

public struct BodyParameters {
    var values: [String : Any] = [:]
    init(with values: [String : Any] = [:]) {
        self.values = values
    }
}
