//
//  CodableVariableDictionary.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import Foundation

public struct CodableVariableDictionary: Codable {
    public let variables: [StringValue: CodableVariableValue]
    public var values: [StringValue: any EditableVariableValue] { variables.mapValues { $0.value } }
    
    public init(variables: [StringValue: CodableVariableValue]) {
        self.variables = variables
    }
    
    public init(variables: [StringValue: any EditableVariableValue]) {
        self.variables = variables.mapValues { .init(value: $0) }
    }
}
