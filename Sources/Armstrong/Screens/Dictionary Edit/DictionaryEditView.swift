//
//  DictionaryEditView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

struct DictionaryEditView: View {
    let scope: Scope
    let title: String
    @Binding var value: DictionaryValue
    let onUpdate: (DictionaryValue) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Type")
                    .bold()
                    .scope(scope)
                
                Spacer()
                value.type.editView(
                    scope: scope, title: title, onUpdate: {
                        self.value.type = $0
                        onUpdate(value)
                    }
                )
            }
            
            ForEach(value.elements.map { ($0.key, $0.value) }, id: \.0) { (key, value) in
                HStack {
                    VStack {
                        key.editView(scope: scope, title: "Key", onUpdate: { editedElement in
                            onMain {
                                _ = try? self.value.update(oldKey: key, to: editedElement)
                                onUpdate(self.value)
                            }
                        })
                        
                        value.editView(scope: scope, title: "Value", onUpdate: { editedElement in
                            self.value.elements[key] = editedElement
                            onUpdate(self.value)
                        })
                    }
                    
                    ElementDeleteButton(color: scope.color) {
                        self.value.elements.removeValue(forKey: key)
                        onUpdate(self.value)
                    }
                }
            }
            
            addButton()
        }
        .frame(maxWidth: .infinity)
    }
    
    func addButton() -> some View {
        SwiftUI.Button {
            guard let type = value.type.value.editableType else { return }
            value.elements[StringValue(value: "_NEW_")] = type.makeDefault()
            onUpdate(value)
        } label: {
            Image(systemName: "plus.app.fill").scope(scope)
        }
    }
}

