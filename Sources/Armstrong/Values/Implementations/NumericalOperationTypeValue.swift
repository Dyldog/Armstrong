//
//  NumericalOperationType.swift
//  AppApp
//
//  Created by Dylan Elliott on 28/11/2023.
//

import SwiftUI

public enum NumericalOperationType: String, Codable, CaseIterable, Titleable, CodeRepresentable {
    case add
    case subtract
    case mulitply
    case divide
    case power
    case mod
    
    public var title: String {
        switch self {
        case .add: "plus"
        case .subtract: "minus"
        case .mulitply: "times"
        case .divide: "divided by"
        case .power: "to the power of"
        case .mod: "mod"
        }
    }
    
    public func `func`<T: Numeric>() -> (T, T) -> T {
        switch self {
        case .add: return { $0 + $1}
        case .subtract: return { $0 - $1}
        case .mulitply: return { $0 * $1}
        case .divide: return { $0 / $1}
        case .power: return { $0 ** $1 }
        case .mod: return { $0 % $1}
        }
    }
    
    public var codeRepresentation: String {
        switch self {
        case .add: return "+"
        case .subtract: return "-"
        case .mulitply: return "*"
        case .divide: return "/"
        case .power: return "**"
        case .mod: return "%"
        }
    }
}

public final class NumericalOperationTypeValue: PrimitiveEditableVariableValue {
    public static var categories: [ValueCategory] = [.numbers]
    public static var type: VariableType { .numericalOperationType }
    
    public var value: NumericalOperationType
    
    public var protoString: String { value.title }
    public var valueString: String { protoString }
    
    public init(value: NumericalOperationType) {
        self.value = value
    }
    
    public static func makeDefault() -> NumericalOperationTypeValue {
        .init(value: .mod)
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(.numericalOperationType, "add")
    }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        self
    }
    
    public func operate<T: NumericValue>(lhs: T, rhs: T) -> T {
        return .init(value: value.func()(lhs.value, rhs.value))
    }
}
