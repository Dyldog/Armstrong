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
            
            EditableListView(
                scope: scope,
                elements: value.elements,
                content: { index, element in
                    element.editView(scope: scope.next, title: "\(title)[\(index)]") { editedElement in
                        value.elements[index] = editedElement
                        onUpdate(value)
                    }
                },
                onAdd: { index in
                    guard let type = value.type.editableType else { return }
                    let view = type.makeDefault()
                    if index <= value.elements.count {
                        value.elements.append(view)
                    } else {
                        value.elements[index] = view
                    }
                    
                    onUpdate(value)
                },
                onRemove: { index in
                    value.elements.remove(at: index)
                    onUpdate(value)
                }
            )
        }
    }
}

struct EditableListView<T, C: View>: View {
    
    let scope: Scope
    let elements: [T]
    let content: (Int, T) -> C
    let onAdd: (Int) -> Void
    let onAddLongPress: (Int) -> Void
    let onRemove: (Int) -> Void
    
    init(scope: Scope, elements: [T], content: @escaping (Int, T) -> C, onAdd: @escaping (Int) -> Void, onAddLongPress: @escaping (Int) -> Void = { _ in }, onRemove: @escaping (Int) -> Void) {
        self.scope = scope
        self.elements = elements
        self.content = content
        self.onAdd = onAdd
        self.onAddLongPress = onAddLongPress
        self.onRemove = onRemove
    }
    
    var body: some View {
        VStack {
            addButton(index: 0)
            
            ForEach(enumerated: elements) { (index, element) in
                HStack {
                    content(index, element)
                    
                    ElementDeleteButton(color: scope.next.color) {
                        onRemove(index)
                    }
                }
                
                addButton(index: index + 1)
            }
            .multilineTextAlignment(.center)
        }
    }
    
    func addButton(index: Int) -> some View {
        AddButton(
            action: {
                onAdd(index)
            }, longPress: {
                onAddLongPress(index)
            }, scope: scope
        )
        .frame(maxWidth: .infinity)
    }
}

struct AddButton: View {
    let action: Block
    let longPress: Block
    let scope: Scope
    
    init(action: @escaping Block, longPress: @escaping Block = {}, scope: Scope) {
        self.action = action
        self.longPress = longPress
        self.scope = scope
    }
    
    var body: some View {
        LongPressButton {
            action()
        } longPressAction: {
            longPress()
        } label: {
            Image(systemName: "plus.app.fill").scope(scope)
        }
        .padding(4)
    }
}
