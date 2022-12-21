//
//  NetworkError.swift
//
//  Created by Sean Langhi on 9/23/22.
//

import Foundation

// MARK: - Enum cases

public enum NetworkError: Error {
    case requestCreationFailed,
         httpStatusCode(Int),
         empty,
         decodingError,
         unknown
}
