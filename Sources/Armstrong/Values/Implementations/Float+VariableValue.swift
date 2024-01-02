//
//  Float+VariableValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 30/11/2023.
//

import SwiftUI

// sourcery: categories = ".numbers"
extension Float: StringRepresentableValue, Numeric {
    public static var defaultValue: Float = 0
    
    public static func %(lhs: Float, rhs: Float) -> Float {
        lhs.truncatingRemainder(dividingBy: rhs)
    }
    
    public var floatValue: Float { self }
}

