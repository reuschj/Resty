//
//  AuthenticationValue.swift
//  Resty
//
//  Created by Justin Reusch on 3/29/20.
//

import Foundation

public protocol AuthenticationValue {
    var type: AuthenticationScheme { get set }
}
