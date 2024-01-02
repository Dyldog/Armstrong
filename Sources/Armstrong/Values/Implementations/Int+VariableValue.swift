//
//  Int+VariableValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

// sourcery: categories = ".numbers"
extension Int: StringRepresentableValue, Numeric {
    public static var defaultValue: Int = 69
    
    public var floatValue: Float { .init(self) }
}

extension IntValue {
    public static func int(_ value: Int) -> IntValue {
        .init(value: value)
    }
}

extension AnyValue {
    public static func int(_ value: Int) -> AnyValue {
        IntValue.int(value).any
    }
}
