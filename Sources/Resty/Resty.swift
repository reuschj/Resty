//
//  Resty.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

typealias RESTCompletionHandler = (Response) -> Void
typealias SuccessHandler = (Data, Response) -> Void
typealias FailureHandler = (RESTCallError, Response) -> Void

typealias DecodeCompletionHandler<T: Decodable> = (Response, Result<T, RESTCallError>) -> Void

/**
 Optional misc. settings for REST calls
 */
struct RequestOptions {
    var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    var timeoutInterval: Double = Double.infinity
}

/**
 The main tool to store all information for a REST call, send the request to the server and manage the response
 */
struct Resty {
    var url: URL
    var queries: URLQueries? = nil
    var fullURL: URL
    var method: HTTPMethod = .get {
        didSet { urlRequest.httpMethod = self.method.rawValue }
    }
    var headers: HTTPHeaders? = nil
    var body: Body? = nil
    private var urlRequest: URLRequest
    var httpBody: Data? { urlRequest.httpBody }
    var cachePolicy: URLRequest.CachePolicy { urlRequest.cachePolicy }
    var timeoutInterval: Double { urlRequest.timeoutInterval }
    
    private var semaphore = DispatchSemaphore (value: 0)
    
    init(
        url: URL,
        queries: URLQueries? = nil,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions()
    ) {
        self.url = url
        self.queries = queries
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queries?.queryItems
        self.fullURL = urlComponents?.url ?? url
        self.method = method
        self.body = body
        self.headers = headers
        if let contentType = body?.contentType {
            let httpHeader = HTTPHeader(with: .contentType(contentType))
            if var headers = self.headers {
                if !headers.has(key: httpHeader.key) {
                    headers.set(httpHeader, forKey: httpHeader.key)
                }
            } else {
                self.headers = HTTPHeaders(with: httpHeader)
            }
        }
        self.urlRequest = URLRequest(url: url, cachePolicy: setup.cachePolicy, timeoutInterval: setup.timeoutInterval)
        urlRequest.httpMethod = method.rawValue
        self.headers?.map { urlRequest.setValue($0.value.value, forHTTPHeaderField: $0.value.key) }
        urlRequest.httpBody = body?.data
    }
    init(
        url: String,
        queries: URLQueries? = nil,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions()
    ) {
        self.init(url: URL(string: url)!, queries: queries, method: method, headers: headers, body: body, setup: setup)
    }
    
    mutating func send(onCompletion completionHandler: @escaping RESTCompletionHandler) {
        let task = URLSession.shared.dataTask(with: urlRequest) { [self] data, urlResponse, error in
            let response = Response(
                data: data,
                response: urlResponse,
                error: error,
                successCondition: Response.defaultSuccessCondition
            )
            completionHandler(response)
            self.semaphore.signal()
        }
        task.resume()
        self.semaphore.wait()
    }
    
    mutating func send(onfailure failureHandler: @escaping FailureHandler, onSuccess successHandler: @escaping SuccessHandler) {
        self.send { response in
            switch response.result {
            case .success(let data):
                successHandler(data, response)
            case .failure(let restCallError):
                failureHandler(restCallError, response)
            }
        }
    }
    
    mutating func decode<T: Decodable>(_ type: T.Type, onCompletion completionHandler: @escaping DecodeCompletionHandler<T>) {
        self.send { response in
            let decoder = JSONDecoder()
            switch response.result {
            case .success(let data):
                do {
                    let value = try decoder.decode(type, from: data)
                    completionHandler(response, .success(value))
                } catch {
                    completionHandler(response, .failure(.couldNotDecode(data: data)))
                }
            case .failure(let restCallError):
                completionHandler(response, .failure(restCallError))
            }
        }
        
    }
    
    /**
     Static -------------------------------------------------
     */
    
    // GET ------------------------------
    
    static func get(
        _ url: URL,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .get, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func get(
        _ url: String,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.get(URL(string: url)!, queries: queries, setup: setup, onCompletion: completionHandler)
    }
    
    // POST ------------------------------
    
    static func post(
        _ url: URL,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .post, headers: headers, body: body, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func post(
        _ url: String,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.post(URL(string: url)!, queries: queries, headers: headers, body: body, setup: setup, onCompletion: completionHandler)
    }
    
    // PUT ------------------------------
    
    static func put(
        _ url: URL,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .put, headers: headers, body: body, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func put(
        _ url: String,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.put(URL(string: url)!, queries: queries, headers: headers, body: body, setup: setup, onCompletion: completionHandler)
    }
    
    // DELETE ------------------------------
    
    static func delete(
        _ url: URL,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .delete, headers: headers, body: body, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func delete(
        _ url: String,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.delete(URL(string: url)!, queries: queries, headers: headers, body: body, setup: setup, onCompletion: completionHandler)
    }
    
    // PATCH ------------------------------
    
    static func patch(
        _ url: URL,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .patch, headers: headers, body: body, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func patch(
        _ url: String,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.patch(URL(string: url)!, queries: queries, headers: headers, body: body, setup: setup, onCompletion: completionHandler)
    }
    
    // Decode ------------------------------
    
    static func decode<T: Decodable>(
        _ url: URL,
        method: HTTPMethod = .get,
        type: T.Type,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping DecodeCompletionHandler<T>
    ) {
        var restCall = Self(url: url, queries: queries, method: method, headers: headers, body: body, setup: setup)
        restCall.decode(type, onCompletion: completionHandler)
    }
    static func decode<T: Decodable>(
        _ url: String,
        method: HTTPMethod = .get,
        type: T.Type,
        queries: URLQueries? = nil,
        headers: HTTPHeaders? = nil,
        body: Body? = nil,
        setup: RequestOptions = RequestOptions(),
        onCompletion completionHandler: @escaping DecodeCompletionHandler<T>
    ) {
        Self.decode(URL(string: url)!, method: method, type: type, queries: queries, headers: headers, body: body, setup: setup, onCompletion: completionHandler)
    }
}
