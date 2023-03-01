//
//  MockNetworkProvider.swift
//  
//
//  Created by Sean Langhi on 2/28/23.
//

import Combine
import Foundation

// MARK: - Memory footprint

public class MockNetworkProvider: Networking {
    public var simulatedLatency: TimeInterval = 1.5
    public var simulatedError: NetworkError?
}

// MARK: - Singleton instance

public extension MockNetworkProvider {
    static let shared = MockNetworkProvider()
}

// MARK: - `Networking` conformance

public extension MockNetworkProvider {
    func sendRequest<R: Requestable>(
        for requestable: R
    ) -> AnyPublisher<R.Response, NetworkError> {
        guard
            let mockable = requestable as? any Mockable,
            let response = mockable.mockResponse as? R.Response
        else {
            return Fail(error: .noMockAvailable)
                .delay(for: .init(simulatedLatency), scheduler: RunLoop.main)
                .eraseToAnyPublisher()
        }
        switch simulatedError {
            case .some(let error):
                return Fail(error: error)
                    .delay(for: .init(simulatedLatency), scheduler: RunLoop.main)
                    .eraseToAnyPublisher()
            case .none:
                return Just(response)
                    .delay(for: .init(simulatedLatency), scheduler: RunLoop.main)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
        }
    }
}
