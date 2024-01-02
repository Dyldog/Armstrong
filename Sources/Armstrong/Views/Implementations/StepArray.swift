//
//  StepArray.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import SwiftUI
import DylKit

// sourcery: skipCodable
public final class StepArray: Codable, EditableVariableValue {
    
    public static let categories: [ValueCategory] = [.computation]
    public static var type: VariableType { .stepArray }
    
    public var value: [any StepType]
    
    public init(value: [any StepType]) {
        self.value = value
    }
    
    public static func makeDefault() -> StepArray {
        .init(value: .init())
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.value = try container.decode(CodableStepList.self).values
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        fatalError()
    }
    
    public var protoString: String { value.map { $0.protoString }.joined(separator: ",\n") }
    
    public var valueString: String { value.map { $0.protoString }.joined(separator: ",\n") }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        self
//        try run(with: variables)
//        return  variables.value(for: "$0") ?? NilValue()
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (StepArray) -> Void) -> AnyView {
        return ExpandableStack(scope: scope, title: title) {
            HStack {
                ProtoText(self.protoString)
            }
        } content: {
            ActionListView(
                scope: scope.next,
                title: "Edit Steps",
                padSteps: false,
                steps: self.value
            ) { [weak self] in
                guard let self = self else { return }
                self.value = $0
                onUpdate(self)
            }
        }.any
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(CodableStepList(steps: value))
    }
    
    public func run(with variables: Variables, and scope: Scope) throws {
        for step in value {
            try step.run(with: variables, and: scope)
        }
    }
}

extension StepArray: Sequence {
    public struct Iterator: IteratorProtocol {
        var index: Int = 0
        let values: [any StepType]
        
        public mutating func next() -> (any StepType)? {
            let model = values[safe: index]
            index += 1
            return model
        }
    }
    
    public func makeIterator() -> Iterator {
        .init(values: value)
    }
}

extension StepArray: CodeRepresentable {
    public var codeRepresentation: String {
        """
        {
        \(declarationCodeRepresentation)
        }
        """
    }
    
    var declarationCodeRepresentation: String {
        var lastOutputIndex: Int = 0
        
        var outputs: [String] = []
        
        for (_, step) in value.enumerated() {
            var prefix = ""
            
            if step is any ValueStep {
                prefix = "let OUT\(lastOutputIndex + 1) = "
            }
            
            outputs.append(
                prefix + step.codeRepresentation
                    .replacingOccurrences(of: "$0", with: "OUT\(lastOutputIndex)")
            )
            
            if step is any ValueStep {
                lastOutputIndex += 1
            }
        }
        
        return outputs.joined(separator: "\n")
    }
}

extension View {
    func onFirstAppear(_ key: String, message: String, in defaults: UserDefaults = .standard) -> some View {
        let key = "\(key)_SHOWN"
        return self
            .popover(isPresented: .init(get: {
                !defaults.bool(forKey: key)
            }, set: {
                if $0 == true {
                    defaults.set(true, forKey: key)
                }
            }), content: {
                Text(message).font(.footnote)
            })
    }
}
