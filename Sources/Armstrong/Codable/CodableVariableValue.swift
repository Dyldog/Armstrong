//
//  CodableVariableValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import Foundation

public struct CodableVariableValue {
    let type: String
    let value: any EditableVariableValue
    
    init(value: any EditableVariableValue) {
        self.value = value
        self.type = typeString(Swift.type(of: value))
    }
}
