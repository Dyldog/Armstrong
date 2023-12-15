//
//  ActionListView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

struct ActionListView: View {
    let scope: Scope
    let title: String
    @State var showAddIndex: Int?
    @State var steps: [any StepType]
    let onUpdate: ([any StepType]) -> Void
    
    var body: some View {
        VStack {
            addButton(index: 0)
            
            ForEach(enumerated: steps) { (index, element) in
                VStack(spacing: 0) {
                    HStack {
                        Text(type(of: element).title)
                            .bold()
                            .scope(scope.next)
                        
                        ElementDeleteButton(color: scope.next.color) {
                            steps = steps.removing(at: index)
                            onUpdate(steps)
                        }
                    }
                    
                    element.editView(scope: scope.next, title: title) { value in
                        onUpdate(steps.replacing(value, at: index))
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.white))
                .frame(maxWidth: .infinity)
                
                addButton(index: index + 1)
            }
        }
        .frame(maxWidth: .infinity).sheet(item: $showAddIndex) { index in
            AddActionView { newStep in
                steps = steps.inserting(newStep, at: index)
                onUpdate(steps)
                showAddIndex = nil
            }
        }
    }
    
    func addButton(index: Int) -> some View {
        SwiftUI.Button {
            showAddIndex = index
        } label: {
            Image(systemName: "plus.app.fill")
        }
        .padding(4)
        .scope(scope)
    }
}
