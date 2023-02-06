//
//  ServiceConsumer.swift
//  
//
//  Created by Sean Langhi on 2/6/23.
//

import Combine
import LoadingState

// MARK: - Memory footprint

/// A generic shim that can stand between your UI and any state-generating service, decoupling your UI from the service's implementation details.
public class ServiceConsumer<Input, Output>: ObservableObject {

    private let _attemptLoad: (Input) -> Void
    @Published public var state: State = .notStarted

    // MARK: - Init

    public init(
        upstream: Source,
        attemptLoad: @escaping (Input) -> Void
    ) {
        self._attemptLoad = attemptLoad
        upstream.assign(to: &$state)
    }
}

// MARK: - Inner types

public extension ServiceConsumer {
    typealias State = LoadingState<Output, NetworkError>
    typealias Source = AnyPublisher<State, Never>
}

// MARK: - APIs

public extension ServiceConsumer {
    func attemptLoad(with input: Input) {
        _attemptLoad(input)
    }
}

// MARK: - Type enrichment

public extension ServiceConsumer where Input == EmptyInput {
    func attemptLoad() {
        _attemptLoad(())
    }
}
