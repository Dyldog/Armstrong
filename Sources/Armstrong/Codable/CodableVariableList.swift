//
//  CodableVariableList.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import Foundation

public struct CodableVariableList: Codable {
    public let variables: [CodableVariableValue]
    public var values: [any EditableVariableValue] { variables.map { $0.value } }
    
    public init(variables: [CodableVariableValue]) {
        self.variables = variables
    }
    
    public init(variables: [any EditableVariableValue]) {
        self.variables = variables.map { .init(value: $0) }
    }
}
