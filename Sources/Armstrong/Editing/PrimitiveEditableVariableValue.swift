//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import Foundation

protocol PrimitiveEditableVariableValue: EditableVariableValue where Primitive.AllCases: RandomAccessCollection {
    associatedtype Primitive: CaseIterable & Hashable & Titleable & CodeRepresentable
    var value: Primitive { get set }
}

extension PrimitiveEditableVariableValue {
    var codeRepresentation: String { value.codeRepresentation }
}
