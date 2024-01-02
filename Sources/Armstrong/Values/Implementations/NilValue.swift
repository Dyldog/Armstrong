//
//  NilValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 28/11/2023.
//

import SwiftUI

// sourcery: variableTypeName = "`nil`", skipCodable
public final class NilValue: EditableVariableValue {
    public static let categories: [ValueCategory] = [.helperValues]
    public static var type: VariableType { .nil }
    
    private var DUMMYVALUE = "DUMMY"
    
    public var protoString: String { "NIL" }
    public var valueString: String { protoString }
    
    public init() {
    }
    
    public static func makeDefault() -> NilValue {
        .init()
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (NilValue) -> Void) -> AnyView {
        EmptyView().any
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(.nil, "add")
    }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        self
    }
}

extension NilValue: CodeRepresentable {
    public var codeRepresentation: String { "nil" }
}
