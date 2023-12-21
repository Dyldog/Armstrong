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
    let scope: Scope
    let screen: ScreenValue
    
    let onContentUpdate: (ScreenValue) -> Void
    let onRuntimeUpdate: (@escaping Block) -> Void
    
    @EnvironmentObject var variables: Variables
    @Binding var error: VariableValueError?
    
    @State var content: MakeableStack?
    
    public init(isRunning: Bool, showEditControls: Bool, scope: Scope, screen: ScreenValue, onContentUpdate: @escaping (ScreenValue) -> Void, onRuntimeUpdate: @escaping (@escaping Block) -> Void, error: Binding<VariableValueError?>) {
        self.isRunning = isRunning
        self.showEditControls = showEditControls
        self.screen = screen
        self.onContentUpdate = onContentUpdate
        self.onRuntimeUpdate = onRuntimeUpdate
        self._error = error
        self.scope = scope
    }
    
    public var body: some View {
        MakeableWrapperView(
            isRunning: isRunning,
            showEditControls: showEditControls, 
            scope: scope,
            view: content ?? MakeableLabel.withText("LOADING!"),
            onContentUpdate: { _ in
                fatalError()
            },
            onRuntimeUpdate: onRuntimeUpdate,
            error: $error
        )
        
        .task(id: variables.hashValue) {
            do {
                if isRunning {
                    let varsWithArgs = variables.copy()
                    let stack: MakeableStack = try await screen.value(with: variables, and: scope)
                    let variables: DictionaryValue = try await screen.arguments.value(with: variables, and: scope)
                    varsWithArgs.set(from: variables)
                    self.content = try await stack.value(with: varsWithArgs, and: scope)
                } else {
                    self.content = .init([MakeableLabel.withText(screen.protoString)])
                }
            } catch {
                print(error)
            }
        }
    }
}
