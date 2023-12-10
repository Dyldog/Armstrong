//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import Foundation

public extension CompositeEditableVariableValue {
    var properties: [Properties: any EditableVariableValue] {
        Properties.allCases.reduce(into: [:], {
            $0[$1] = value(for: $1)
        })
    }
    
    var constructor: some ViewConstructor {
        EditableViewConstructor<Self>(properties: properties) { props in
            Self.make {
                props[$0] ?? $0.defaultValue
            }
        }
    }
}
