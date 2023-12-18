//
//  CodableVariableDictionary.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import Foundation

public struct CodableVariableDictionary: Codable {
    public let variables: [String: CodableVariableValue]
    public var values: [String: any EditableVariableValue] { variables.mapValues { $0.value } }
    
    public init(variables: [String: CodableVariableValue]) {
        self.variables = variables
    }
    
    public init(variables: [String: any EditableVariableValue]) {
        self.variables = variables.mapValues { .init(value: $0) }
    }
}
