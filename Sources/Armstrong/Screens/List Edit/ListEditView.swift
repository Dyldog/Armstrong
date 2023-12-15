//
//  ListEditView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

struct ListEditView: View {
    let scope: Scope
    let title: String
    @Binding var value: ArrayValue
    let onUpdate: (ArrayValue) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text("Type")
                    .bold()
                    .scope(scope)
                
                Spacer()
                value.type.editView(scope: scope, title: "\(title)[type]", onUpdate: {
                    value.type = $0
                    value.elements = []
                    onUpdate(value)
                })
            }
            
            addButton(index: 0)
            
            ForEach(enumerated: value.elements) { (index, element) in
                HStack {
                    VStack {
                        element.editView(scope: scope.next, title: "\(title)[\(index)]") { editedElement in
                            value.elements[index] = editedElement
                            onUpdate(value)
                        }
                    }
                    
                    ElementDeleteButton(color: scope.next.color) {
                        remove(at: index)
                    }
                }
                
                addButton(index: index + 1)
            }
            .multilineTextAlignment(.center)
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
            Image(systemName: "plus.app.fill").scope(scope)
        }
        .padding(4)
    }
    
    func remove(at index: Int) {
        value.elements.remove(at: index)
        onUpdate(value)
    }
}
