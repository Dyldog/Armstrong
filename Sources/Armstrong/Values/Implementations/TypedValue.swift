//
//  TypedValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 29/11/2023.
//

import SwiftUI

public enum TypedValueOptionType: Int, CaseIterable, Hashable {
    case variable
    case constant
    case result
    
    public func makeDefault<T: EditableVariableValue>() -> TypedValueOption<T> {
        switch self {
        case .variable: return .variable(.makeDefault())
        case .constant: return .constant(T.makeDefault())
        case .result: return .result(ResultValue.makeDefault())
        }
    }
    
    public var title: String {
        switch self {
        case .variable: return "VAR"
        case .constant: return "CONSTANT"
        case .result: return "RESULT"
        }
    }
    
    public var valueTitle: String {
        switch self {
        case .variable: return "Name"
        case .constant: return "Value"
        case .result: return "Steps"
        }
    }
}

public enum TypedValueOption<T: TypeableValue>: Codable {
    case variable(Variable)
    case constant(T)
    case result(ResultValue)
    
    public var title: String {
        type.title
    }
    
    public var variable: Variable? {
        switch self {
        case .variable(let variable): return variable
        case .constant, .result: return nil
        }
    }
    
    public var constant: T? {
        switch self {
        case .variable, .result: return nil
        case .constant(let constant): return constant
        }
    }
    
    public var result: ResultValue? {
        switch self {
        case .variable, .constant: return nil
        case .result(let result): return result
        }
    }
    
    public var value: any EditableVariableValue {
        switch self {
        case .variable(let variable): return variable
        case .constant(let constant): return constant
        case .result(let result): return result
        }
    }
    
    public func value(with variables: Binding<Variables>, and scope: Scope) throws -> T {
        return try value.value(with: variables, and: scope)
    }
    
    public var type: TypedValueOptionType {
        switch self {
        case .variable: return .variable
        case .constant: return .constant
        case .result: return .result
        }
    }
}

// sourcery: skipCopying, skipVariableType, skipCodable
public typealias TypeableValue = EditableVariableValue & Codable


// sourcery: variableTypeName = "typedValue", skipVariableType
public final class TypedValue<T: TypeableValue>: EditableVariableValue, Codable, ObservableObject {
    
    public static var type: VariableType { fatalError() }
    
    public var type: VariableType { T.type }
    
    public var value: TypedValueOption<T> { didSet { objectWillChange.send() } }
    
    public init(value: TypedValueOption<T>) {
        self.value = value
    }
    
    public static func variable(_ variable: Variable) -> TypedValue {
        .init(value: .variable(variable))
    }
    
    public static func value(_ value: T) -> TypedValue {
        .init(value: .constant(value))
    }
    
    public static func result(_ result: ResultValue) -> TypedValue {
        .init(value: .result(result))
    }
    
    public static func makeDefault() -> TypedValue<T> {
        .init(value: .constant(T.makeDefault()))
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        return try value.value.add(other)
    }
    
    public var protoString: String { "\(value.title): \(value.value.protoString)" }
    public var valueString: String { "\(value.title): \(value.value.valueString)" }
    
    public func value(with variables: Binding<Variables>, and scope: Scope) throws -> VariableValue {
        try value.value.value(with: variables, and: scope)
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (TypedValue<T>) -> Void) -> AnyView {
        return ExpandableStack(scope: scope, title: title) { [weak self] in
            HStack {
                ProtoText(text: self?.protoString ?? "")
            }
        } content: {
            VStack {
                HStack {
                    Text("Type").bold().scope(scope.next)
                    Spacer()
                    Picker("Type", selection: .init(get: { [weak self] in
                        self?.value.type ?? .constant
                    }, set: { [weak self] (new: TypedValueOptionType) in
                        guard let self = self else { return }
                        self.value = new.makeDefault()
                        onUpdate(self)
                    })) {
                        ForEach(TypedValueOptionType.allCases) {
                            Text($0.title).tag($0)
                        }
                    }
                    .pickerScope(scope.next)
                    .any
                }
                
                self.value.value.editView(scope: scope.next, title: self.value.type.valueTitle) { [weak self] in
                    guard let self else { return }
                    switch self.value.type {
                    case .constant:
                        guard let constantValue = $0 as? T else { return }
                        self.value = .constant(constantValue)
                    case .variable:
                        guard let variableValue = $0 as? Variable else { return }
                        self.value = .variable(variableValue)
                    case .result:
                        guard let resultValue = $0 as? ResultValue else { return }
                        self.value = .result(resultValue)
                    }
                    onUpdate(self)
                }
            }
            .tint(scope.color)
            .foregroundStyle(scope.color)
        }
        .any
    }
}

extension TypedValue: CodeRepresentable {
    public var codeRepresentation: String {
        value.value.codeRepresentation
    }
}

public extension EditableVariableValue {
    var typed: TypedValue<Self> { .value(self) }
}
