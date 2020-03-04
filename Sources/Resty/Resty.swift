//
//  Resty.swift
//  Resty
//
//  Created by Justin Reusch on 2/28/20.
//

import Foundation

typealias RESTCompletionHandler = (Result<Data, RestyError>, Response, Int) -> Void
typealias FailureHandler = (RestyError, Response, Int) -> Void
typealias SuccessHandler = (Data, Response, Int) -> Void

typealias DecodeCompletionHandler<T: Decodable> = (Result<T, RestyError>, Response, Int) -> Void

struct RequestSetup {
    var headers: HTTPHeaders? = nil
    var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    var timeoutInterval: Double = Double.infinity
}

struct Resty {
    var url: URL
    var queries: URLQueries? = nil
    var fullURL: URL
    var method: HTTPMethod = .get {
        didSet {
            urlRequest.httpMethod = self.method.rawValue
        }
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
        body: Body? = nil,
        setup: RequestSetup = RequestSetup()
    ) {
        self.url = url
        self.queries = queries
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queries?.queryItems
        self.fullURL = urlComponents?.url ?? url
        self.method = method
        self.body = body
        self.headers = setup.headers
        if let contentType = body?.contentType {
            if var headers = self.headers {
                let contentTypeKey = HTTPHeaders.CommonRequestHeaders.contentType.description
                if !headers.has(key: contentTypeKey) {
                    headers.set(contentType, for: contentTypeKey)
                }
            } else {
                self.headers = HTTPHeaders(with: HTTPHeaders.HTTPHeader(key: .contentType, value: contentType))
            }
        }
        self.urlRequest = URLRequest(url: url, cachePolicy: setup.cachePolicy, timeoutInterval: setup.timeoutInterval)
        urlRequest.httpMethod = method.rawValue
        self.headers?.map { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        urlRequest.httpBody = body?.data
    }
    init(
        url: String,
        queries: URLQueries? = nil,
        method: HTTPMethod = .get,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup()
    ) {
        self.init(url: URL(string: url)!, queries: queries, method: method, body: body, setup: setup)
    }
    
    mutating func send(onCompletion completionHandler: @escaping RESTCompletionHandler) {
        let task = URLSession.shared.dataTask(with: urlRequest) { [self] data, urlResponse, error in
            let response = Response(data: data, response: urlResponse, error: error, successCondition: Response.defaultSuccessCondition)
            completionHandler(response.result, response, response.statusCode)
            self.semaphore.signal()
        }
        task.resume()
        self.semaphore.wait()
    }
    mutating func send(onfailure failureHandler: @escaping FailureHandler, onSuccess successHandler: @escaping SuccessHandler) {
        self.send { result, response, statusCode in
            switch result {
            case .success(let data):
                successHandler(data, response, statusCode)
            case .failure(let restCallError):
                failureHandler(restCallError, response, statusCode)
            }
        }
    }
    
    mutating func decode<T: Decodable>(_ type: T.Type, onCompletion completionHandler: @escaping DecodeCompletionHandler<T>) {
        self.send { result, response, statusCode in
            let decoder = JSONDecoder()
            switch result {
            case .success(let data):
                do {
                    let value = try decoder.decode(type, from: data)
                    completionHandler(.success(value), response, statusCode)
                } catch {
                    completionHandler(.failure(.couldNotDecode(data)), response, statusCode)
                }
            case .failure(let restCallError):
                completionHandler(.failure(restCallError), response, statusCode)
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
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .get, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func get(
        _ url: String,
        queries: URLQueries? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.get(URL(string: url)!, queries: queries, setup: setup, onCompletion: completionHandler)
    }
    
    // POST ------------------------------
    
    static func post(
        _ url: URL,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .post, body: body, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func post(
        _ url: String,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.post(URL(string: url)!, queries: queries, body: body, setup: setup, onCompletion: completionHandler)
    }
    
    // PUT ------------------------------
    
    static func put(
        _ url: URL,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .put, body: body, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func put(
        _ url: String,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.put(URL(string: url)!, queries: queries, body: body, setup: setup, onCompletion: completionHandler)
    }
    
    // DELETE ------------------------------
    
    static func delete(
        _ url: URL,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .delete, body: body, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func delete(
        _ url: String,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.delete(URL(string: url)!, queries: queries, body: body, setup: setup, onCompletion: completionHandler)
    }
    
    // PATCH ------------------------------
    
    static func patch(
        _ url: URL,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        var restCall = Self(url: url, queries: queries, method: .patch, body: body, setup: setup)
        restCall.send(onCompletion: completionHandler)
    }
    static func patch(
        _ url: String,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping RESTCompletionHandler
    ) {
        Self.patch(URL(string: url)!, queries: queries, body: body, setup: setup, onCompletion: completionHandler)
    }
    
    // Decode ------------------------------
    
    static func decode<T: Decodable>(
        _ url: URL,
        method: HTTPMethod = .get,
        type: T.Type,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping DecodeCompletionHandler<T>
    ) {
        var restCall = Self(url: url, queries: queries, method: method, body: body, setup: setup)
        restCall.decode(type, onCompletion: completionHandler)
    }
    static func decode<T: Decodable>(
        _ url: String,
        method: HTTPMethod = .get,
        type: T.Type,
        queries: URLQueries? = nil,
        body: Body? = nil,
        setup: RequestSetup = RequestSetup(),
        onCompletion completionHandler: @escaping DecodeCompletionHandler<T>
    ) {
        Self.decode(URL(string: url)!, method: method, type: type, queries: queries, body: body, setup: setup, onCompletion: completionHandler)
    }
}
