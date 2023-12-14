//
//  StepArray.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import SwiftUI
import DylKit

public final class StepArray: Codable, EditableVariableValue {
    
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
    
    public func value(with variables: Variables) async throws -> VariableValue {
        self
    }
    
    public func editView(title: String, onUpdate: @escaping (StepArray) -> Void) -> AnyView {
        return HStack {
            Text(protoString)
            SheetButton(title: {
                Image(systemName: "ellipsis.circle.fill")
            }) { [weak self] in
                guard let self = self else { return Text("WASNIL").any }
                return ActionListView(title: "Edit Steps", steps: self.value, onUpdate: { [weak self] in
                    guard let self = self else { return }
                    self.value = $0
                    onUpdate(self)
                }).any
            } onDismiss: {
                
            }
        }.any
    }
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(CodableStepList(steps: value))
    }
    
    public func run(with variables: Variables) async throws {
        for step in value {
            try await step.run(with: variables)
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
