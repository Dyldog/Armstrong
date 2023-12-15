//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import SwiftUI

public protocol EditableVariableValue: AnyObject, VariableValue, ViewEditable {
    static func makeDefault() -> Self
    func editView(scope: Scope, title: String, onUpdate: @escaping (Self) -> Void) -> AnyView
}
