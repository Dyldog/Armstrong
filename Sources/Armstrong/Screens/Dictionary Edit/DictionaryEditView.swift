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
            
            ForEach(enumerated: value.elements.map { (StringValue(value: $0.key), $0.value) }) { (index, element) in
                HStack {
                    VStack {
                        let oldKey = element.0.value
                        element.0.editView(scope: scope, title: "Key", onUpdate: { editedElement in
                            onMain {
                                _ = try? self.value.update(oldKey: oldKey, to: editedElement.value)
                                onUpdate(self.value)
                            }
                        })
                        
                        element.1.editView(scope: scope, title: "Value", onUpdate: { editedElement in
                            self.value.elements[element.0.value] = editedElement
                            onUpdate(self.value)
                        })
                    }
                    
                    ElementDeleteButton(color: scope.color) {
                        self.value.elements.removeValue(forKey: element.0.value)
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
            value.elements["_NEW_"] = type.makeDefault()
            onUpdate(value)
        } label: {
            Image(systemName: "plus.app.fill").scope(scope)
        }
    }
}

