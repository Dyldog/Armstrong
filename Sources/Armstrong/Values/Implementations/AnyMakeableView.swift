//
//  AnyMakeable.swift
//  AppApp
//
//  Created by Dylan Elliott on 29/11/2023.
//

import SwiftUI
import DylKit

// sourcery: variableTypeName = "view", skipCodable
public final class AnyMakeableView: EditableVariableValue {
    
    public static var type: VariableType { .view }
    public var value: any MakeableView
    
    public var protoString: String { value.protoString }
    public var valueString: String { value.valueString }
    
    public init(value: any MakeableView) {
        self.value = value
    }
    
    public static func makeDefault() -> AnyMakeableView {
        .init(value: MakeableLabel.withText("TEXT"))
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        return try value.add(other)
    }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        try await value.value(with: variables)
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (AnyMakeableView) -> Void) -> AnyView {
        VStack(spacing: 0) {
            HStack {
                Text("Type").bold().scope(scope)
                Spacer()
                Picker("", selection: .init(get: {
                    HashableBox(Swift.type(of: self.value), hash: { $0.type })
                }, set: { new in
                    self.value = new.value.makeDefault()
                    onUpdate(self)
                })) {
                    ForEach(AALibrary.shared.views.map { $0.type }) {
                        Text($0.title).tag($0)
                    }
                }
                .pickerScope(scope)
                .any
            }
            
            value.editView(scope: scope, title: "\(title)[value]") {[weak self] in
                guard let self = self else { return }
                self.value = $0
                onUpdate(self)
            }
        }.any
    }
}

extension AnyMakeableView: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            value: try container.decode(CodableMakeableView.self, forKey: .value).value
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(CodableMakeableView(value: value), forKey: .value)
    }
}

extension MakeableView {
    public var any: AnyMakeableView {
        .init(value: self)
    }
}

extension AnyMakeableView: CodeRepresentable {
    public var codeRepresentation: String {
        value.codeRepresentation
    }
}
