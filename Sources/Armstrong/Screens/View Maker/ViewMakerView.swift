//
//  ViewMakerView.swift
//  AppApp
//
//  Created by Dylan Elliott on 20/11/2023.
//

import SwiftUI
import DylKit

public struct ViewMakerView: View {
    let isWidget: Bool
    @StateObject var viewModel: ViewMakerViewModel
    @State var showInitActions: Bool = false
    
    public init(isWidget: Bool = false, viewModel: ViewMakerViewModel) {
        self.isWidget = isWidget
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    private var content: some View {
        CenterStack {
            return MakeableStackView(
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
        }
        .environmentObject(viewModel.variables)
    }
    
    public var body: some View {
        if isWidget {
            content
        } else {
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        content
                            .frame(minHeight: geometry.size.height)
                    }
                }
            }
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
                        SheetButton(
                            showSheet: $showInitActions,
                            title: { Text("Init Actions") }
                        ) {
                            NavigationStack {
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
