//
//  Authorization.swift
//  Resty
//
//  Created by Justin Reusch on 3/29/20.
//

import Foundation

public struct Authorization: AuthenticationValue, CustomStringConvertible {
    public var type: AuthenticationScheme = .basic
    private var _credentials: String? = nil
    private var _username: String = ""
    private var _password: String = ""
    public var credentials: String? {
        get { _credentials }
        set {
            let result: String? = newValue?.fromBase64()
            self._credentials = newValue
            if let result = result {
                let split = result.split(separator: ":")
                if let username = split.first {
                    self._username = username.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                if let password = split.last {
                    self._password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
    }
    public var username: String {
        get { _username }
        set {
            self._username = newValue
            self._credentials = "\(newValue):\(password)".toBase64()
        }
    }
    public var password: String {
        get { _password }
        set {
            self._password = newValue
            self._credentials = "\(username):\(newValue)".toBase64()
        }
    }
    
    public init(type: AuthenticationScheme = .basic, credentials: String? = nil) {
        self.type = type
        self.credentials = credentials
    }
    
    public init(type: AuthenticationScheme = .basic, username: String, password: String) {
        self.type = type
        self.credentials = nil
        self.username = username
        self.password = password
    }
    
    public var description: String {
        if let credentials = self.credentials {
            return "\(type) \(credentials)"
        } else {
            return "\(type)"
        }
    }
}
