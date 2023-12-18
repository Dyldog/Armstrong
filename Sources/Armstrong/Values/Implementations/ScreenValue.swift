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
    public var name: ScreenNameValue { didSet { objectWillChange.send() } }
    
    public init(id: UUID, name: ScreenNameValue) {
        self.id = id
        self.name = name
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        return try name.add(other)
    }
    
    public var valueString: String { "SCREEN(\(name.valueString)" }
    public var protoString: String { "SCREEN(\(name.protoString)" }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        let name: ScreenNameValue = try await name.value(with: variables)
        let screen = name.screen!
        
        try await screen.initialise(with: variables)
        return try await screen.content
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (ScreenValue) -> Void) -> AnyView {
        ExpandableStack(scope: scope, title: "Screen") { [weak self] in
            ProtoText(text: self?.name.protoString ?? "")
        } content: { [weak self] in
            self?.name.editView(scope: scope, title: "Name", onUpdate: { [weak self] in
                guard let self else { return }
                self.name = $0
                onUpdate(self)
            })
        }
        .any
    }
}

typealias ScreenValueView = MakeableScreenView

extension ScreenValue: MakeableView, Codable {
    
    public static func defaultValue(for property: Properties) -> any EditableVariableValue {
        switch property {
        case .name: ScreenNameValue.makeDefault()
        }
    }
    
    public func insertValues(into variables: Variables) async throws {
//        let view: any MakeableView = try await value(with: variables)
//        try await view.insertValues(into: variables)
    }
}

extension ScreenValue: CodeRepresentable {
    public var codeRepresentation: String {
        return "TODO"
    }
}

