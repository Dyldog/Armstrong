//
//  ColorValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 29/11/2023.
//

import SwiftUI

public final class ColorValue: EditableVariableValue {
    public static let categories: [ValueCategory] = [.visual]
    public static var type: VariableType { .color }
    
    public var value: Color
    
    public var protoString: String { "\(value)" }
    public var valueString: String { protoString }
    
    public init(value: Color) {
        self.value = value
    }
    
    public static func makeDefault() -> ColorValue {
        .init(value: .blue)
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (ColorValue) -> Void) -> AnyView {
        HStack {
            Text(title).bold().scope(scope)
            Spacer()
            ColorPicker("Set the background color", selection: .init(get: { [weak self] in
                self?.value ?? .blue
            }, set: { [weak self] in
                guard let self = self else { return }
                self.value = $0
                onUpdate(self)
            })).labelsHidden()
        }.any
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(.color, "add")
    }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        self
    }
}

extension ColorValue: CodeRepresentable {
    public var codeRepresentation: String {
        "Color(hex: \"\(value.toHex!)\")"
    }
}

