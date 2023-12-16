//
//  DictionaryValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

// sourcery: skipCodable
public final class DictionaryValue: EditableVariableValue, ObservableObject {
    
    public static var type: VariableType { .dictionary }
    
    public var type: VariableTypeValue
    public var elements: [StringValue: any EditableVariableValue]
    
    public var protoString: String {
        """
        {
        \(elements.map { "\t\($0.key.protoString): \($0.value.protoString)" }.joined(separator: ", "))
        }
        """
    }
    
    public var valueString: String {
        elements.map { "\($0.key.valueString): \($0.value.valueString)" }.joined(separator: ", ")
    }
    
    public init(type: VariableTypeValue, elements: [StringValue: any EditableVariableValue]) {
        self.type = type
        self.elements = elements
    }
    
    public static func makeDefault() -> DictionaryValue {
        .init(
            type: VariableTypeValue(value: .string),
            elements: [StringValue: any EditableVariableValue]()
        )
    }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        var mapped: [StringValue: (any VariableValue)?] = [:]
        for (key, value) in elements {
            mapped[key] = try await value.value(with: variables)
        }
        
        return DictionaryValue(
            type: type,
            elements: elements.compactMapValues { $0 }
        )
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        if let otherArray = other as? DictionaryValue, otherArray.type.value == type.value {
            elements.merge(otherArray.elements, uniquingKeysWith: { _, new in new })
            return self
        } else {
            throw VariableValueError.wrongTypeForOperation
        }
    }
    
    public func update(oldKey: StringValue, to newKey: StringValue) throws -> VariableValue {
        guard let value = elements[oldKey] else { throw VariableValueError.valueNotFoundForVariable(oldKey.protoString) }
        elements.removeValue(forKey: oldKey)
        elements[newKey] = value
        return self
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (DictionaryValue) -> Void) -> AnyView {
        ExpandableStack(scope: scope, title: title) { [weak self] in
                ProtoText(text: self?.protoString ?? "")
            } content: {
                DictionaryEditView(scope: scope, title: title, value: .init(get: {
                    self
                }, set: {
                    self.elements = $0.elements
                }), onUpdate: {
                    self.elements = $0.elements
                    onUpdate(self)
                })
            }
        .any
    }
}

extension DictionaryValue: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case elements
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            type: try container.decode(VariableTypeValue.self, forKey: .type),
            elements: try container.decode(CodableVariableDictionary.self, forKey: .elements).values
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CodableVariableDictionary(variables: elements), forKey: .elements)
        try container.encode(type, forKey: .type)
    }
}


extension DictionaryValue {
    public static func from(_ dictionary: [String: Any]) -> DictionaryValue {
        return DictionaryValue(
            type: VariableTypeValue(value: .string),
            elements: dictionary.reduce(into: [StringValue: any EditableVariableValue](), {
                let value: VariableValue
                switch $1.value {
                case let float as Float: value = FloatValue(value: float)
                case let int as Int: value = IntValue(value: int)
                case let nsNumber as NSNumber: value = FloatValue(value: nsNumber.floatValue)
                case let array as [Any]:
                    value = ArrayValue.from(array)
                case let dictionary as [String: Any]:
                    value = DictionaryValue.from(dictionary)
                case let string as String: value = StringValue(value: string)
                default: fatalError()
                }
                
                $0[StringValue(value: $1.key)] = value as? any EditableVariableValue
            })
        )
    }
}

extension DictionaryValue: CodeRepresentable {
    public var codeRepresentation: String {
        """
        [
        \(elements.map { "\t\($0.key.codeRepresentation): \($0.value.codeRepresentation)"})
        ]
        """
    }
}
