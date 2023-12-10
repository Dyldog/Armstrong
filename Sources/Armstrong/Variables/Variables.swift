//
//  Variables.swift
//  AppApp
//
//  Created by Dylan Elliott on 20/11/2023.
//

import Foundation
import DylKit
import Combine

public final class Variables: Equatable, ObservableObject, Hashable, Identifiable, Copying {
    
    @MainActor public var id: String { keyString + valueString }
//    var objectWillChange = PassthroughSubject<Void, Never>()
    
    @MainActor private(set) var variables: [String: VariableValue]
    
    @MainActor var keys: [String] { Array(variables.keys) }
    
    public init(values: [String: VariableValue] = [:]) {
        variables = values
    }
    
    @MainActor public func value(for name: String) -> VariableValue? {
        objectWillChange.send()
        return variables[name]?.copy()
    }
    
    @MainActor public func set(_ value: VariableValue, for name: String) {
        objectWillChange.send()
        variables[name] = value.copy()
    }
    
    @MainActor public func set(from other: Variables) {
        objectWillChange.send()
        for (key, value) in other.variables {
            if self.value(for: key)?.valueString != value.valueString {
                set(value, for: key)
            }
        }
    }
    
    @MainActor public static func == (lhs: Variables, rhs: Variables) -> Bool {
        let isEqual = (lhs.keyString == rhs.keyString) && (lhs.valueString == rhs.valueString)
        return isEqual
    }
    
    @MainActor public func hash(into hasher: inout Hasher) {
        hasher.combine(variables.mapValues { $0.valueString })
    }
    
    @MainActor public func copy() -> Variables {
        return Variables(
            values: variables.mapValues { $0.copy() }
        )
    }
}

private extension Variables {
    @MainActor var keyString: String {
        variables.keys.sorted().joined()
    }
    
    @MainActor var valueString: String {
        variables.values.map { $0.valueString }.sorted().joined()
    }
}
