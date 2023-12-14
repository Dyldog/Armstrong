//
//  NilValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 28/11/2023.
//

import SwiftUI

// sourcery: variableTypeName = "`nil`"
public final class NilValue: EditableVariableValue {
    
    public static var type: VariableType { .nil }
    
    private var DUMMYVALUE = "DUMMY"
    
    public var protoString: String { "NIL" }
    public var valueString: String { protoString }
    
    public init() {
    }
    
    public static func makeDefault() -> NilValue {
        .init()
    }
    
    public func editView(title: String, onUpdate: @escaping (NilValue) -> Void) -> AnyView {
        Text(protoString).any
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(.nil, "add")
    }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        self
    }
}

extension NilValue: CodeRepresentable {
    public var codeRepresentation: String { "nil" }
}
