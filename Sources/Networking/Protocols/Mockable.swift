//
//  Mockable.swift
//  
//
//  Created by Sean Langhi on 2/28/23.
//

import Foundation

// MARK: - Protocol requirements

public protocol Mockable: Requestable {
    var mockResponse: Response { get }
}
