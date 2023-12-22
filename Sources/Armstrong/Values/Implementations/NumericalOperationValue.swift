//
//  NumericalOperation.swift
//  AppApp
//
//  Created by Dylan Elliott on 28/11/2023.
//

import Foundation

public final class NumericalOperationValue: CompositeEditableVariableValue {
    
    public static var type: VariableType { .numericalOperation }
    
    public var protoString: String { "\(lhs.protoString) \(operation.protoString) \(rhs.protoString)" }
    public var valueString: String  { "\(lhs.valueString) \(operation.valueString) \(rhs.valueString)" }
    
    public var lhs: AnyValue
    public var rhs: AnyValue
    public var operation: NumericalOperationTypeValue
    
    public init(lhs: AnyValue, rhs: AnyValue, operation: NumericalOperationTypeValue) {
        self.lhs = lhs
        self.rhs = rhs
        self.operation = operation
    }
    
    public static func defaultValue(for property: Properties) -> EditableVariableValue {
        switch property {
        case .lhs: return AnyValue(value: StringValue(value: "A"))
        case .rhs: return AnyValue(value: StringValue(value: "B"))
        case .operation: return NumericalOperationTypeValue(value: .mod)
        }
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(.numericalOperation, "add")
    }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        guard
            let lhs = try lhs.value(with: variables.copy(), and: scope) as? any NumericValue,
            let rhs = try rhs.value(with: variables.copy(), and: scope) as? any NumericValue
        else { throw VariableValueError.wrongTypeForOperation }
        
        return try lhs.perform(operation: operation.value, with: rhs)
    }
}

extension NumericalOperationValue: CodeRepresentable {
    public var codeRepresentation: String {
        "\(lhs.codeRepresentation) \(operation.codeRepresentation) \(rhs.codeRepresentation)"
    }
}
