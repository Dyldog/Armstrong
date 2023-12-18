//
//  File.swift
//  
//
//  Created by Dylan Elliott on 18/12/2023.
//

import Foundation
import SwiftUI
import DylKit

public final class ScreenNameValue: EditableVariableValue, ObservableObject {
    
    public static var type: VariableType { .screenName }
    public var value: String { didSet { objectWillChange.send() } }
    var screen: Screen! { Self.screen(for: value) }
    
    public init(value: String) {
//        guard Self.screen(for: value) != nil else { return nil }
        self.value = value
    }
    
    private static func screen(for name: String) -> Screen? {
        AALibrary.shared.allScreens.first(where: { $0.name == name })
    }
    
    public static func makeDefault() -> ScreenNameValue {
        .init(value: "Counting Button")
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(.screenName, "add")
    }
    
    public var protoString: String { value }
    public var valueString: String { value }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        self
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (ScreenNameValue) -> Void) -> AnyView {
        
        HStack {
            Text(title).bold().scope(scope)
            
            Spacer()
            
            Picker(selection: .init(get: { [weak self] in
                (self?.value ?? "ERROR")
            }, set: { [weak self] in
                guard let self else { return }
                self.value = $0
                onUpdate(self)
            })) {
                ForEach(AALibrary.shared.allScreens) {
                    Text($0.name).tag($0.name)
                }
            } label: {
                Text(title).bold().scope(scope)
            }
            .pickerScope(scope)

        }
        .any
    }
}

extension ScreenNameValue: CodeRepresentable {
    public var codeRepresentation: String { "TODO" }
}

