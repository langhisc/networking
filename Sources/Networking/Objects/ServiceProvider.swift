//
//  ServiceProvider.swift
//  
//
//  Created by Sean Langhi on 2/6/23.
//

import Combine
import LoadingState

// MARK: - Memory footprint

/// A generic shim that can stand between your UI and any state-generating service, decoupling your UI from the service's implementation details.
open class ServiceProvider<Input, Output>: ObservableObject {

    @Published public var state: State = .notStarted

    private let networkProvider: any NetworkProvider

    // MARK: - Init

    public init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }

    // MARK: - APIs

    open func attemptLoad(with input: Input) {
        fatalError("Your `ServiceProvider subclass must override the method `attemptLoad(with:)`.")
    }
}

// MARK: - Inner types

public extension ServiceProvider {
    typealias State = LoadingState<Output, NetworkError>
    typealias Source = AnyPublisher<State, Never>
}

// MARK: - Type enrichment

public extension ServiceProvider where Input == EmptyInput {
    func attemptLoad() {
        attemptLoad(with: ())
    }
}
