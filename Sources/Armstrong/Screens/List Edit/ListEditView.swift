//
//  ListEditView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit
import Armstrong

struct ListEditView: View {
    let title: String
    @Binding var value: ArrayValue
    let onUpdate: (ArrayValue) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("Type")
                    Spacer()
                    value.type.editView(title: "\(title)[type]", onUpdate: {
                        value.type = $0
                        value.elements = []
                        onUpdate(value)
                    })
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.white))
                .padding()
                
                addButton(index: 0)
                
                ForEach(enumerated: value.elements) { (index, element) in
                    HStack {
                        VStack {
                            element.editView(title: "\(title)[\(index)]") { editedElement in
                                value.elements[index] = editedElement
                                onUpdate(value)
                            }
                        }
                        
                        ElementDeleteButton {
                            remove(at: index)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.white))
                    .padding()
                    
                    addButton(index: index + 1)
                }
                .multilineTextAlignment(.center)
            }
            .navigationTitle(title)
            .background(.gray.opacity(0.1))
        }
    }
    
    func addButton(index: Int) -> some View {
        SwiftUI.Button {
            guard let type = value.type.editableType else { return }
            let view = type.makeDefault()
            if index <= value.elements.count {
                value.elements.append(view)
            } else {
                value.elements[index] = view
            }
            
            onUpdate(value)
        } label: {
            Image(systemName: "plus.app.fill").foregroundStyle(.blue)
        }
    }
    
    func remove(at index: Int) {
        value.elements.remove(at: index)
        onUpdate(value)
    }
}
