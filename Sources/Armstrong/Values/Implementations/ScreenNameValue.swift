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
    public static let categories: [ValueCategory] = [.helperValues]
    public static var type: VariableType { .screenName }
    public var value: String { didSet { objectWillChange.send() } }
    
    public init(value: String) {
        self.value = value
    }
    
    func screen(from scope: Scope) -> Screen? {
        scope.screen(named: value)
    }
    
    public static func makeDefault() -> ScreenNameValue {
        .init(value: "Counting Button")
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(.screenName, "add")
    }
    
    public var protoString: String { value }
    public var valueString: String { value }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
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
                ForEach(scope.screenNames) {
                    Text($0).tag($0)
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

