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
    @State var selectedTypeIndex: Int
    var selectedType: any EditableVariableValue.Type { AALibrary.shared.values[selectedTypeIndex] }
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
                Picker("Type", selection: $selectedTypeIndex) {
                    ForEach(enumerated: AALibrary.shared.values) { (index, element) in
                        Text(element.type.title).tag(index)
                    }
                }
                .pickerScope(scope)
            }
            
            value.editView(scope: scope, title: "Value", onUpdate: {
                self.value = $0
                onUpdate($0)
            })
        }
        .buttonStyle(.plain)
        .navigationTitle(name)
        .onChange(of: selectedTypeIndex, perform: { value in
            self.value = selectedType.makeDefault()
            onUpdate(self.value)
        })
    }
}
