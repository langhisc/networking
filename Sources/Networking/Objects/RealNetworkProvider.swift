//
//  RealNetworkProvider.swift
//
//  Created by Sean Langhi on 4/27/21.
//

import Combine
import Foundation

// MARK: - Memory footprint

public struct RealNetworkProvider: Networking {

    public let urlSession: URLSession

    // MARK: - Init

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
}

// MARK: - Singleton instance

public extension RealNetworkProvider {
    static let shared = RealNetworkProvider(
        urlSession: URLSession(configuration: .ephemeral)
    )
}

// MARK: - `Networking` conformance

public extension RealNetworkProvider {
    func sendRequest<R: Requestable>(
        for requestable: R
    ) -> AnyPublisher<R.Response, NetworkError> {
        guard let request = requestable.urlRequest else {
            return Fail<R.Response, NetworkError>(error: .requestCreationFailed)
                .eraseToAnyPublisher()
        }
        typealias ParsingResult = Result<R.Response, NetworkError>
        return urlSession.dataTaskPublisher(for: request)
            .map(Self.parseOutput)
            .tryMap { (result: ParsingResult) in try result.get() }
            .mapError { $0 as? NetworkError ?? .unknown }
            .eraseToAnyPublisher()
    }
}

// MARK: - Inner logic

public extension RealNetworkProvider {
    static func parseOutput<ExpectedPayload: Decodable>(
        _ output: (data: Data, response: URLResponse)
    ) -> Result<ExpectedPayload, NetworkError> {
        guard let response = output.response as? HTTPURLResponse else {
            return .failure(.empty)
        }
        let decoder = JSONDecoder()
        guard (200...299).contains(response.statusCode) else {
            return .failure(.httpStatusCode(response.statusCode))
        }
        if let decodedFromData = try? decoder.decode(ExpectedPayload.self, from: output.data) {
            return .success(decodedFromData)
        }
        else if output.data.isEmpty,
                let idealEmptyJSONData = "{}".data(using: .utf8),
                let decodedFromEmpty = try? decoder.decode(ExpectedPayload.self, from: idealEmptyJSONData) {
            return .success(decodedFromEmpty)
        }
        else {
            return .failure(.decodingError)
        }
    }
}

