//
//  File.swift
//  
//
//  Created by Dylan Elliott on 18/12/2023.
//

import Foundation
import DylKit
import SwiftUI

public final class ScreenValue: EditableVariableValue, ObservableObject {
    
    public let id: UUID
    
    public static var type: VariableType { .screen }
    
    @Published public var name: ScreenNameValue
    @Published public var arguments: DictionaryValue
    
    public init(id: UUID, name: ScreenNameValue, arguments: DictionaryValue) {
        self.id = id
        self.name = name
        self.arguments = arguments
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        return try name.add(other)
    }
    
    public var valueString: String { "SCREEN(\(name.valueString))" }
    public var protoString: String { "SCREEN(\(name.protoString))" }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        let name: ScreenNameValue = try name.value(with: variables, and: scope)
        guard let screen = name.screen(from: scope) else { throw VariableValueError.screenDoesNotExist(name.protoString) }
        
        
         variables.set(from: try arguments.value(with: variables, and: scope) as DictionaryValue)
        try screen.initialise(with: variables, and: scope, useInputVarsForInit: true)
        return try screen.content.value(with: variables, and: scope.withScreens(
            screens: screen.subscreens.map { $0.name },
            factory: { name in screen.subscreens.first(where: { $0.name == name }) }
        ))
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (ScreenValue) -> Void) -> AnyView {
        ExpandableStack(scope: scope, title: "Screen") { [weak self] in
            ProtoText(text: self?.name.protoString ?? "")
        } content: { [weak self] in
            if let self {
                VStack {
                    self.name.editView(scope: scope, title: "Name", onUpdate: { [weak self] in
                        guard let self else { return }
                        self.name = $0
                        onUpdate(self)
                    })
                    
                    ForEach(enumerated: (self.name.screen(from: scope)?.initVariables.elements ?? [:]).map { (key: $0.key, value: $0.value)}) { (index, element) in
                        (self.arguments.elements[element.key] ?? element.value).editView(scope: scope, title: element.key) { [weak self] in
                            guard let self else { return }
                            self.arguments.elements[element.key] = $0
                            onUpdate(self)
                        }
                    }
                }
            } else {
                EmptyView()
            }
        }
        .any
    }
}

typealias ScreenValueView = MakeableScreenView

extension ScreenValue: MakeableView, Codable {
    
    public static func defaultValue(for property: Properties) -> any EditableVariableValue {
        switch property {
        case .name: ScreenNameValue.makeDefault()
        case .arguments: DictionaryValue.makeDefault()
        }
    }
    
    public func insertValues(into variables: Variables, with scope: Scope) throws {
//        let view: any MakeableView = try value(with: variables)
//        try view.insertValues(into: variables)
    }
}

extension ScreenValue: CodeRepresentable {
    public var codeRepresentation: String {
        return "TODO"
    }
}

