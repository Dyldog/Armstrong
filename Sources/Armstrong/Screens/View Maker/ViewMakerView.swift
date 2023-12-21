//
//  ViewMakerView.swift
//  AppApp
//
//  Created by Dylan Elliott on 20/11/2023.
//

import SwiftUI
import DylKit

public struct ViewMakerView: View {
    @StateObject var viewModel: ViewMakerViewModel
    
    public init(viewModel: ViewMakerViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        Self._printChanges()
        return GeometryReader { geometry in
            VStack {
                ScrollView {
                    CenterStack {
                        if viewModel.hasFinishedFirstLoad {
                            MakeableStackView(
                                isRunning: !viewModel.makeMode,
                                showEditControls: viewModel.makeMode, 
                                scope: viewModel.scope,
                                stack: viewModel.content,
                                onContentUpdate: { content in
                                    viewModel.content = content
                                }, onRuntimeUpdate: {
                                    viewModel.onRuntimeUpdate(completion: $0)
                                },
                                error: $viewModel.error
                            ).any
                        } else {
                            ProgressView().progressViewStyle(.circular).any
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
            .environmentObject(viewModel.variables)
//            .navigationTitle(viewModel.title)
            .if(viewModel.showErrors, modified: { view in
                view.alert(item: $viewModel.error, content: {
                    .init(title: Text("Error"), message: Text($0.localizedDescription))
                })
            })
            .toolbar {
                ToolbarItem(placement: .principal) {
                    TextField("Title", text: $viewModel.title)
                        .multilineTextAlignment(.center)
                }
            }
            .toolbar {
                HStack {
                    if viewModel.makeMode {
                        SheetButton(title: { Text("Init Actions") }) {
                            NavigationView {
                                ScrollView {
                                    ViewInitValuesView(
                                        scope: viewModel.scope,
                                        initVariables: viewModel.screen.initVariables,
                                        initVariablesUpdate: {
                                            viewModel.updateInitVariables($0)
                                        },
                                        initActions: viewModel.screen.initActions,
                                        initActionsUpdate: {
                                            viewModel.updateInitActions($0)
                                        },
                                        subscreens: viewModel.screen.subscreens,
                                        subscreensUpdate: {
                                            viewModel.updateSubscreens($0)
                                        })
                                }
                                .background(.gray.opacity(0.1))
                                .navigationTitle("Init Actions")
                            }
                        } onDismiss: {
                            //
                        }
                        
                        VStack(spacing: 0) {
                            Text("Errors").font(.footnote)
                            Toggle("Errors", isOn: $viewModel.showErrors)
                                .toggleStyle(.switch)
                                .fixedSize()
                                .labelsHidden()
                        }
                    }
                    
                    if viewModel.showEdit {
                        VStack(spacing: 0) {
                            Text("Edit").font(.footnote)
                            Toggle("Edit", isOn: $viewModel.makeMode)
                                .toggleStyle(.switch)
                                .fixedSize()
                                .labelsHidden()
                        }
                    }
                }
            }
        }
    }
}
