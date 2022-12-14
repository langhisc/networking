//
//  Networking.swift
//
//  Created by Sean Langhi on 4/27/21.
//

import Combine
import Foundation

// MARK: - Protocol requirements

public protocol Networking {
    func sendRequest<R: Requestable>(
        for requestable: R
    ) -> AnyPublisher<R.Response, NetworkError>
}
