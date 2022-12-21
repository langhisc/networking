//
//  Requestable.swift
//
//  Created by Sean Langhi on 4/27/21.
//

import Foundation

// MARK: - Protocol requirements

public protocol Requestable {

    var baseURL: String { get }
    var route: String { get }
    var body: Data? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }

    associatedtype Input
    associatedtype Response: Decodable

    init(input: Input)
}

// MARK: - Type enrichment

public extension Requestable {

    var url: URL? {
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        urlComponents.path = route
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return urlComponents.url
    }

    var urlRequest: URLRequest? {
        guard let url = self.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = String(method)
        request.httpBody = body
        request.allHTTPHeaderFields = headers
        return request
    }
}

public extension Requestable where Input == Void {
    init() {
        self.init(input: ())
    }
}
