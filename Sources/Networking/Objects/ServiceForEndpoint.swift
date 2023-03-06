//
//  ServiceForEndpoint.swift
//
//  Created by Sean Langhi on 12/9/22.
//

import Combine
import Foundation
import LoadingState
import SwiftUI

// MARK: - Memory footprint

/// A generic class for implementing a simple concrete service that makes one request to one endpoint.
public class ServiceForEndpoint<Endpoint: Requestable, Output>: ObservableObject {

    private let networkProvider: NetworkProvider
    private let transformEndpointResponse: (Endpoint.Response) -> LoadingState<Output, NetworkError>

    @Published public var loadingState: LoadingState<Output, NetworkError> = .notStarted

    // MARK: - Init

    public init(
        networkProvider: NetworkProvider,
        transformEndpointResponse: @escaping (Endpoint.Response) -> LoadingState<Output, NetworkError>
    ) {
        self.networkProvider = networkProvider
        self.transformEndpointResponse = transformEndpointResponse
    }
}

public extension ServiceForEndpoint where Endpoint.Response == Output {
    /// Available when `Endpoint.Response` is the same type as `Output`.  Uses a basic mapping strategy that directly wraps the response into the `.success` case of `LoadingState`.
    convenience init(networkProvider: NetworkProvider) {
        self.init(
            networkProvider: networkProvider,
            transformEndpointResponse: { .success($0) }
        )
    }
}

// MARK: - APIs

public extension ServiceForEndpoint {
    func contactEndpoint(with input: Endpoint.Input) {
        loadingState = .loading
        let requestable = Endpoint(input: input)
        networkProvider.sendRequest(for: requestable)
            .map(transformEndpointResponse)
            .catch { Just(.failure($0)) }
            .receive(on: DispatchQueue.main)
            .assign(to: &$loadingState)
    }
}

public extension ServiceForEndpoint where Endpoint.Input == Void {
    func contactEndpoint() {
        contactEndpoint(with: ())
    }
}
