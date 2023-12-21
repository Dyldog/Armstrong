//
//  File.swift
//
//
//  Created by Dylan Elliott on 21/12/2023.
//

import SwiftUI
import DylKit

struct ViewInitValuesView: View {
    let scope: Scope
    let initVariables: DictionaryValue
    let initVariablesUpdate: (DictionaryValue) -> Void
    let initActions: StepArray
    let initActionsUpdate: (StepArray) -> Void
    let subscreens: [Screen]
    let subscreensUpdate: ([Screen]) -> Void
    
    var body: some View {
        initVariables.editView(
            scope: scope,
            title: "Init Variables"
        ) {
            initVariablesUpdate($0)
        }
        .padding()
        
        initActions.editView(
            scope: scope,
            title: "InitActions") {
                initActionsUpdate($0)
            }
            .padding()
        
        // Sub Screens
        ExpandableStack(
            scope: scope,
            title: "Sub-Screens") {
                EmptyView()
            } content: {
                EditableListView(
                    scope: scope,
                    elements: subscreens
                ) { index, element in
                    HStack {
                        SheetButton(
                            title: { Text(element.name).bold() }
                        ) {
                            NavigationView {
                                ViewMakerView(viewModel: .init(
                                    scope: scope, 
                                    screen: element,
                                    makeMode: true,
                                    onUpdate: {
                                        subscreensUpdate(subscreens.replacing($0, at: index))
                                    }
                                ))
                            }
                        } onLongPress: {
                            UIPasteboard.general.copy(element)
                        }
                        Spacer()
                        ProtoText(element.content.protoString)
                    }
                    .scope(scope.next)
                    
                } onAdd: { index in
                    subscreensUpdate(subscreens.inserting(
                        .init(
                            id: .init(),
                            name: randomString(length: 5).capitalized,
                            initVariables: .init(elements: [:]),
                            initActions: .init(value: []),
                            subscreens: [],
                            content: .init([])
                        ),
                        at: index
                    ))
                } onAddLongPress: { index in
                    guard let screen = UIPasteboard.general.pasteScreen() else { return }
                    subscreensUpdate(subscreens.inserting(screen, at: index))
                } onRemove: { index in
                    subscreensUpdate(subscreens.removing(at: index))
                }
            }
            .padding()
    }
}
