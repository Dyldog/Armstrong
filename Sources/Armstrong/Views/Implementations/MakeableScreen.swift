//
//  File.swift
//  
//
//  Created by Dylan Elliott on 18/12/2023.
//

import SwiftUI
import DylKit

public struct MakeableScreenView: View {
    let isRunning: Bool
    let showEditControls: Bool
    let screen: ScreenValue
    
    let onContentUpdate: (ScreenValue) -> Void
    let onRuntimeUpdate: (@escaping Block) -> Void
    
    @EnvironmentObject var variables: Variables
    @Binding var error: VariableValueError?
    
    @State var content: (stack: MakeableStack, variables: DictionaryValue)?
    
    public init(isRunning: Bool, showEditControls: Bool, screen: ScreenValue, onContentUpdate: @escaping (ScreenValue) -> Void, onRuntimeUpdate: @escaping (@escaping Block) -> Void, error: Binding<VariableValueError?>) {
        self.isRunning = isRunning
        self.showEditControls = showEditControls
        self.screen = screen
        self.onContentUpdate = onContentUpdate
        self.onRuntimeUpdate = onRuntimeUpdate
        self._error = error
    }
    
    public var body: some View {
        MakeableWrapperView(
            isRunning: isRunning,
            showEditControls: showEditControls,
            view: content?.stack ?? MakeableLabel.withText("LOADING!"),
            onContentUpdate: { _ in
                fatalError()
            },
            onRuntimeUpdate: onRuntimeUpdate,
            error: $error
        )
        
        .task(id: variables.hashValue) {
            do {
                if let content {
                    let varsWithArgs = variables.copy()
                    varsWithArgs.set(from: content.variables)
                    let stack: MakeableStack = try await content.stack.value(with: varsWithArgs)
                    self.content = (stack, content.variables)
                } else {
                    if isRunning {
                        let stack: MakeableStack = try await screen.value(with: variables)
                        let variables: DictionaryValue = try await screen.arguments.value(with: variables)
                        content = (stack, variables)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
