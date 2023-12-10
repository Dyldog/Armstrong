//
//  MakeableConstructor.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import Foundation

struct MakeableViewConstructor: ViewConstructor {
    let properties: [String: any EditableVariableValue]
    let factory: ([String: any EditableVariableValue]) -> any MakeableView
    
    init(properties: [String : any EditableVariableValue], factory: @escaping ([String : any EditableVariableValue]) -> any MakeableView) {
        self.properties = properties
        self.factory = factory
    }
    
    var makeableView: any MakeableView {
        factory(properties)
    }
    
    var view: any ViewEditable {
        makeableView
    }
}
