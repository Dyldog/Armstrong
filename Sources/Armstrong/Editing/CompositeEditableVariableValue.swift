//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import Foundation

public typealias VariableUpdater = (any EditableVariableValue) -> Void

public protocol CompositeEditableVariableValue: EditableVariableValue {
    func propertyRows(onUpdate: @escaping (Self) -> Void) -> [(String, any EditableVariableValue, VariableUpdater)]
    
    associatedtype Properties: ViewProperty
    static func make(factory: (Properties) -> any EditableVariableValue) -> Self
    func value(for property: Properties) -> any EditableVariableValue
    func set(_ value: Any, for property: Properties)
    static func defaultValue(for property: Properties) -> any EditableVariableValue
}
