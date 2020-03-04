//
//  RestyError.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

/**
 Possible errors that can be thrown by Resty
 */
enum RestyError: Error, CustomStringConvertible {
    case noData(String)
    case badRequest(Data?)
    case unauthorized(Data?)
    case forbidden(Data?)
    case notFound(Data?)
    case internalServerError(Data?)
    case couldNotDecode(Data?)
    case otherFailureCode(Int, Data?)
    
    /// Gets the data (if any) associated with the error.
    var data: Data? {
        switch self {
        case .noData: return nil
        case .badRequest(let data): return data
        case .unauthorized(let data): return data
        case .forbidden(let data): return data
        case .notFound(let data): return data
        case .internalServerError(let data): return data
        case .couldNotDecode(let data): return data
        case .otherFailureCode(_, let data): return data
        }
    }
    
    /// Gets the HTTP status code associated with error.
    var statusCode: Int {
        switch self {
        case .noData: return 500
        case .badRequest: return 400
        case .unauthorized: return 401
        case .forbidden: return 403
        case .notFound: return 404
        case .internalServerError: return 500
        case .couldNotDecode: return 500
        case .otherFailureCode(let statusCode, _): return statusCode
        }
    }
    
    /// Gets a brief string description associated with the error.
    var description: String {
        switch self {
        case .noData(let errorDescription): return errorDescription
        case .badRequest: return "Bad Request"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not Found"
        case .internalServerError: return "Internal Server Error"
        case .couldNotDecode: return "Could not decode response."
        case .otherFailureCode(let statusCode, _): return "Status Code: \(statusCode)"
        }
    }
}

