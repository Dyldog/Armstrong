//
//  File.swift
//  
//
//  Created by Dylan Elliott on 14/12/2023.
//

import SwiftUI

// sourcery: variableTypeName = "type"
public final class VariableTypeValue: PrimitiveEditableVariableValue {
    
    public static var type: VariableType { .type }
    public var value: VariableType
    
    public var protoString: String { value.protoString }
    
    public var valueString: String { value.valueString }
    
    public init(value: VariableType) {
        self.value = value
    }
    
    public static func makeDefault() -> VariableTypeValue {
        .init(value: .string)
    }
    
    public func value(with variables: Binding<Variables>, and scope: Scope) throws -> VariableValue {
        self
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        fatalError()
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (VariableTypeValue) -> Void) -> AnyView {
        value.editView(scope: scope, title: title) { [weak self] in
            guard let self = self else { return }
            self.value = $0
            onUpdate(self)
        }
    }
    
}
extension VariableType {

    public var valueString: String { protoString }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (VariableType) -> Void) -> AnyView {
        Picker("", selection: .init(get: {
            self
        }, set: { new in
            onUpdate(new)
        })) {
            ForEach(AALibrary.shared.values) {
                Text($0.type.title).tag($0.type)
            }
        }
        .pickerScope(scope)
        .any
    }
}
