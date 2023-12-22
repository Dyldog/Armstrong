//
//  StepValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 29/11/2023.
//

import SwiftUI

public final class ResultValue: EditableVariableValue {
    
    public static var type: VariableType { .result }
    
    public var steps: StepArray
    
    public var protoString: String { "\(steps.protoString)[$0]" }
    public var valueString: String { "\(steps.valueString)[$0]" }
    
    public init(steps: StepArray) {
        self.steps = steps
    }
    
    public static func makeDefault() -> ResultValue {
        .init(steps: .init(value: []))
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (ResultValue) -> Void) -> AnyView {
        steps.editView(scope: scope, title: title) { [weak self] in
            guard let self = self else { return }
            self.steps = $0
            onUpdate(self)
        }
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(.nil, "add")
    }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        for step in steps {
            try step.run(with: variables, and: scope)
        }
        
        let value: (any VariableValue)? = try variables.value(for: "$0")?.value(with: variables, and: scope)
        return value ?? NilValue()
    }
}

extension ResultValue: CodeRepresentable {
    public var codeRepresentation: String {
        steps.codeRepresentation
    }
}
