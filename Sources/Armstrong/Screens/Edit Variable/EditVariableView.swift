//
//  File.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

public struct EditVariableView: View {
    let name: String
    @State var selectedTypeIndex: Int
    var selectedType: any EditableVariableValue.Type { AALibrary.shared.values[selectedTypeIndex] }
    @State var value: any EditableVariableValue
    let onUpdate: (any EditableVariableValue) -> Void
    
    public init(name: String, value: any EditableVariableValue, onUpdate: @escaping (any EditableVariableValue) -> Void) {
        self._value = .init(initialValue: value)
        self.onUpdate = onUpdate
        self.selectedTypeIndex = AALibrary.shared.values.firstIndex { $0.type == type(of: value).type } ?? 0
        self.name = name
    }
        
    public var body: some View {
        VStack {
            HStack {
                Text("Type")
                Spacer()
                Picker("Type", selection: $selectedTypeIndex) {
                    ForEach(enumerated: AALibrary.shared.values) { (index, element) in
                        Text(element.type.title).tag(index)
                    }
                }.pickerStyle(.menu)
            }
            
            HStack {
                if !(value is any CompositeEditableVariableValue) {
                    Text("Value")
                    Spacer()
                }
                value.editView(title: name, onUpdate: {
                    self.value = $0
                    onUpdate($0)
                })
            }
        }
        .buttonStyle(.plain)
        .navigationTitle(name)
        .onChange(of: selectedTypeIndex, perform: { value in
            self.value = selectedType.makeDefault()
            onUpdate(self.value)
        })
    }
}
