//
//  Variable+VariableValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

/// A value that provides a value from the variables
public final class Variable: EditableVariableValue {
    public static var type: VariableType { .variable }
    public var value: any EditableVariableValue
    
    public init(value: any EditableVariableValue) {
        self.value = value
    }
    
    public static func makeDefault() -> Variable {
        .init(value: StringValue(value: "VAR"))
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
//        guard let name = name else { throw VariableValueError.valueNotFoundForVariable }
        return try value.add(other)
    }
    
    public var protoString: String { "$\(value.protoString)" }
    public var valueString: String { "\(value.valueString)" }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        let nameValue = try await value.value(with: variables)
        guard let value = await variables.value(for: nameValue.valueString) else {
            throw VariableValueError.valueNotFoundForVariable(value.protoString)
        }
        return try await value.value(with: variables)
    }
    
    public func editView(title: String, onUpdate: @escaping (Variable) -> Void) -> AnyView {
        self.value.editView(title: title) { [weak self] value in
            guard let self else { return }
            self.value = value
            onUpdate(self)
        }
        .multilineTextAlignment(.trailing)
        .any
    }
}

extension Variable: Codable {
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(value: try container.decode(CodableVariableValue.self, forKey: .name).value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CodableVariableValue(value: value), forKey: .name)
    }
}

extension Variable: CodeRepresentable {
    public var codeRepresentation: String {
        value.valueString
    }
}

extension Variable {
    public static func named(_ name: String) -> Variable {
        .init(value: StringValue(value: name))
    }
}

extension AnyValue {
    public static func variable(named name: String) -> AnyValue {
        Variable.named(name).any
    }
}
