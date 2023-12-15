//
//  Value.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

// sourcery: variableTypeName = "anyValue"
public final class AnyValue: EditableVariableValue {
    
    public static var type: VariableType { .anyValue }
    public var value: any EditableVariableValue
    
    public init(value: any EditableVariableValue) {
        if let value = value as? AnyValue {
            self.value = value.value
        } else {
            self.value = value
        }
    }
    
    public static func makeDefault() -> AnyValue {
        .init(value: StringValue(value: "TEXT"))
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        return try value.add(other)
    }
    
    public var protoString: String { value.protoString }
    public var valueString: String { value.valueString }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        try await value.value(with: variables)
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (AnyValue) -> Void) -> AnyView {
        ExpandableStack(scope: scope, title: title) { [weak self] in
            ProtoText(text: self?.value.protoString ?? "")
        } content: { [weak self] in
            EditVariableView(scope: scope.next, name: title, value: self?.value ?? NilValue()) { [weak self] in
                guard let self else { return }
                self.value = $0
                onUpdate(self)
            }
        }
        .any
    }
}

extension AnyValue: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            value: try container.decode(CodableVariableValue.self, forKey: .value).value
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CodableVariableValue(value: value), forKey: .value)
    }
}

extension EditableVariableValue {
    public var any: AnyValue {
        .init(value: self)
    }
}

extension AnyValue: CodeRepresentable {
    public var codeRepresentation: String { value.codeRepresentation }
}
