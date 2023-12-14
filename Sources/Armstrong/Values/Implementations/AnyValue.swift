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
            self.value = value.copy()
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
    
    public func editView(title: String, onUpdate: @escaping (AnyValue) -> Void) -> AnyView {
        HStack {
            Text(value.protoString)
            SheetButton(title: { Image(systemName: "ellipsis.circle.fill") }) {
                EditVariableView(name: title, value: value) { [weak self] in
                    guard let self = self else { return }
                    self.value = $0
                    onUpdate(self)
                }
            } onDismiss: {
//                onUpdate(self)
            }
        }.any
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
