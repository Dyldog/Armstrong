//
//  File.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

public struct EditVariableView: View {
    let scope: Scope
    let name: String
    var selectedTypeIndex: Int
    @State var value: any EditableVariableValue
    let onUpdate: (any EditableVariableValue) -> Void
    
    public init(scope: Scope, name: String, value: any EditableVariableValue, onUpdate: @escaping (any EditableVariableValue) -> Void) {
        self.scope = scope
        self._value = .init(initialValue: value)
        self.onUpdate = onUpdate
        self.selectedTypeIndex = AALibrary.shared.values.firstIndex { $0.type == type(of: value).type } ?? 0
        self.name = name
    }
        
    public var body: some View {
        VStack {
            HStack {
                Text("Type").bold().scope(scope)
                Spacer()
                TypePickerButton(valueString: type(of: value).type.title, elements: AALibrary.shared.values) {
                    self.value = $0.makeDefault()
                    onUpdate(self.value)
                }
                .scope(scope)
            }
            
            value.editView(scope: scope, title: "Value", onUpdate: {
                self.value = $0
                onUpdate($0)
            })
        }
        .buttonStyle(.plain)
        .navigationTitle(name)
    }
}
