//
//  EditViewView.swift
//  AppApp
//
//  Created by Dylan Elliott on 20/11/2023.
//

import SwiftUI
import DylKit

struct EditViewView: View {
    let title: String
    let scope: Scope
    @StateObject var viewModel: EditViewViewModel
    @State var update: Int = 0
    @State var error: VariableValueError?
    let padSteps: Bool

    init(title: String, scope: Scope, viewModel: EditViewViewModel, padSteps: Bool = true) {
        self.title = title
        self.scope = scope
        self._viewModel = .init(wrappedValue: viewModel)
        self.padSteps = padSteps
    }
    
    var body: some View {
        VStack {
            MakeableWrapperView(
                isRunning: false,
                showEditControls: false, 
                scope: scope,
                view: viewModel.editable,
                onContentUpdate: { _ in },
                onRuntimeUpdate: { _ in },
                error: $error
            )
//                .fixedSize(horizontal: false, vertical: true)
            .id(update)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            )
            .padding()
//            .frame(maxWidth: geometry.size.width)
            .any
            
            ScrollView {
                viewModel.editable.editView(scope: scope, title: "Edit View") {
                    viewModel.editable = $0
                    update += 1
                }
                .if(padSteps, modified: { $0.padding() })
            }
            .navigationTitle("Edit View")
            
        }
        .onDisappear {
            viewModel.onUpdate(viewModel.editable)
        }
    }
    
}
