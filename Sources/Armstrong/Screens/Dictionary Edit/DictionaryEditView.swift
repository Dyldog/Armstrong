//
//  DictionaryEditView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

struct DictionaryEditView: View {
    let title: String
    @Binding var value: DictionaryValue
    let onUpdate: (DictionaryValue) -> Void
    
    var body: some View {
        NavigationView {
            List {
                value.type.editView(
                    title: title, onUpdate: {
                        self.value.type = $0
                        onUpdate(value)
                    }
                )
                
                ForEach(value.elements.map { ($0.key, $0.value) }, id: \.0) { (key, value) in
                    VStack {
                        HStack {
                            key.editView(title: "key", onUpdate: { editedElement in
                                onMain {
                                    _ = try? self.value.update(oldKey: key, to: editedElement)
                                    onUpdate(self.value)
                                }
                            })
                            
                            value.editView(title: key.value, onUpdate: { editedElement in
                                self.value.elements[key] = editedElement
                                onUpdate(self.value)
                            })
                        }
                    }
                }
                
                addButton()
            }
            .navigationTitle(title)
        }
    }
    
    func addButton() -> some View {
        SwiftUI.Button("+") {
            value.elements[StringValue(value: "_NEW_")] = type(of: value).makeDefault()
            onUpdate(value)
        }
    }
}

