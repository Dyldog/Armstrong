//
//  String+VariableValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

// sourcery: skipCodable
public final class StringValue: EditableVariableValue {
    
    public static var type: VariableType { .string }
    public var value: String
    
    public init(value: String) {
        self.value = value
    }
    
    public static func makeDefault() -> StringValue {
        .init(value: "TEXT")
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        value = value + other.valueString
        return self
    }
    
    public var protoString: String { value }
    public var valueString: String { value }
    public func value(with variables: Binding<Variables>, and scope: Scope) throws -> VariableValue { self }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (StringValue) -> Void) -> AnyView {
        HStack {
            Text(title).bold()
            Spacer()
            TextField("", text: .init(get: { [weak self] in
                self?.value ?? "ERROR666"
            }, set: { [weak self] in
                guard let self = self, self.value != $0 else { return }
                self.value = $0
                onUpdate(self)
            }))
            .multilineTextAlignment(.trailing)
        }
        .tint(scope.color)
        .foregroundStyle(scope.color)
        .any
    }
    
    public static func == (lhs: StringValue, rhs: StringValue) -> Bool {
        return lhs.value == rhs.value
    }
}

extension StringValue: Codable {
    enum CodingKeys: String, CodingKey {
        case value
    }
    
    convenience public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(value: try container.decode(String.self, forKey: .value))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }
}

extension StringValue: CodeRepresentable {
    public var codeRepresentation: String {
        "\"\(value)\""
    }
}

extension AnyValue {
    public static func string(_ value: String) -> AnyValue {
        StringValue(value: value).any
    }
}
