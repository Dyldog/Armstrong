//
//  StepType.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

public protocol StepType: ViewEditable, CompositeEditableVariableValue {
    static var title: String { get }
}

public extension StepType {
        
//    var valueString: String { protoString }
    
    func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        self
    }
    
    func add(_ other: VariableValue) throws -> VariableValue {
        fatalError()
    }
}
