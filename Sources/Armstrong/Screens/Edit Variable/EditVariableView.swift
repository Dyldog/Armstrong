//
//  File.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

public struct EditVariableView: View {
    let name: String
    @State var selectedType: VariableType
    @State var value: any EditableVariableValue
    let onUpdate: (any EditableVariableValue) -> Void
    
    public init(name: String, value: any EditableVariableValue, onUpdate: @escaping (any EditableVariableValue) -> Void) {
        self._value = .init(initialValue: value)
        self.onUpdate = onUpdate
        self._selectedType = .init(initialValue: type(of: value).type)
        self.name = name
    }
    
    public var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Type")
                    Spacer()
                    Picker("Type", selection: $selectedType) {
                        ForEach(VariableType.allCases) {
                            Text($0.protoString).tag($0)
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
            .onChange(of: selectedType, perform: { value in
                self.value = value.defaultView
                onUpdate(self.value)
            })
        }
    }
}
