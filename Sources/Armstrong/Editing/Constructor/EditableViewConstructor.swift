//
//  EditableViewConstructor.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import Foundation

public struct EditableViewConstructor<T: CompositeEditableVariableValue>: ViewConstructor {
    let properties: [T.Properties: any EditableVariableValue]
    let factory: ([T.Properties: any EditableVariableValue]) -> any ViewEditable
    
    init(properties: [T.Properties : any EditableVariableValue], factory: @escaping ([T.Properties : any EditableVariableValue]) -> any ViewEditable) {
        self.properties = properties
        self.factory = factory
    }
    
    public var view: any ViewEditable {
        factory(properties)
    }
}
