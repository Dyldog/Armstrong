//
//  VariableValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 20/11/2023.
//

import Foundation
import SwiftUI

/// Defines the properties required to show and edit the type implementing this protocol
public protocol VariableValue: Codable, Copying, CodeRepresentable {
    static var type: VariableType { get }
    func add(_ other: VariableValue) throws -> VariableValue
    var protoString: String { get }
    var valueString: String { get }
    func value(with variables: Variables) async throws -> VariableValue
}

public extension VariableValue {
    func value<T>(with variables: Variables, of type: T.Type = T.self) async throws -> T {
        let value: VariableValue = try await value(with: variables)
        guard let castValue = value as? T else {
            throw VariableValueError.wrongTypeForOperation
        }
        return castValue
    }
}
