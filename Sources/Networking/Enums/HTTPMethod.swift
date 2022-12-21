//
//  HTTPMethod.swift
//
//  Created by Sean Langhi on 9/23/22.
//

import Foundation

// MARK: - Enum cases

public enum HTTPMethod: LosslessStringConvertible {
    case get, post, put, delete
}

// MARK: - Inner data

private let stringsForMethods: [HTTPMethod : String] = [
    .get: "GET",
    .post: "POST",
    .put: "PUT",
    .delete: "DELETE"
]

// MARK: - `LosslessStringConvertible` conformance

public extension HTTPMethod {

    init?(_ description: String) {
        guard let kvPair = stringsForMethods
            .first( where: { $0.value == description.uppercased() } )
        else {
            return nil
        }
        self = kvPair.key
    }

    var description: String {
        stringsForMethods[self] ?? "UNKNOWN"
    }
}
