//
//  EditViewView.swift
//  AppApp
//
//  Created by Dylan Elliott on 20/11/2023.
//

import SwiftUI
import DylKit

struct EditViewView: View {
    @StateObject var viewModel: EditViewViewModel
    @State var update: Int = 0
    @State var error: VariableValueError?
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        MakeableWrapperView(
                            isRunning: false,
                            showEditControls: false,
                            view: viewModel.editable,
                            onContentUpdate: { _ in },
                            onRuntimeUpdate: { _ in },
                            error: $error
                        )
                        .id(update)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                        )
                        .padding()
                        .frame(maxWidth: geometry.size.width)
                        .any
                        
                        ScrollView {
                            viewModel.editable.editView(scope: .init(), title: "Edit View") {
                                viewModel.editable = $0
                                update += 1
                            }
                            .padding()
                        }
                        .navigationTitle("Edit View")
                        
                    }
                }
            }
        }.onDisappear {
            viewModel.onUpdate(viewModel.editable)
        }
    }
    
}
