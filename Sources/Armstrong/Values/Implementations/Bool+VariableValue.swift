//
//  Bool+VariableValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import SwiftUI
import Armstrong

// sourcery: variableTypeName = "boolean"
public final class BoolValue: EditableVariableValue, Codable {
    
    public static var type: VariableType { .boolean }
    
    public var value: Bool
    
    public init(value: Bool) {
        self.value = value
    }
    
    public static var `true`: BoolValue {
        .init(value: true)
    }
    
    public static var `false`: BoolValue {
        .init(value: false)
    }
    
    public static func makeDefault() -> BoolValue {
        .init(value: false)
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(.boolean, "add")
    }
    
    public var protoString: String { valueString }
    
    public var valueString: String { self.value ? "true" : "false" }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        self
    }
    
    public func editView(title: String, onUpdate: @escaping (BoolValue) -> Void) -> AnyView {
        Toggle("", isOn: .init(get: { [weak self] in
            self?.value ?? false
        }, set: { [weak self] in
            guard let self = self else { return }
            self.value = $0
            onUpdate(self)
        })).any
    }
}

extension BoolValue: CodeRepresentable {
    public var codeRepresentation: String {
        switch value {
        case true: "true"
        case false: "false"
        }
    }
}
