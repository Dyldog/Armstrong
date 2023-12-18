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
    
    @State var content: MakeableStack?
    
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
            view: content ?? MakeableLabel.withText("LOADING!"),
            onContentUpdate: { _ in
                fatalError()
            },
            onRuntimeUpdate: onRuntimeUpdate,
            error: $error
        )
        
        .task {
            do {
                if content == nil {
                    content = try await screen.value(with: variables)
                }
            } catch {
                print(error)
            }
        }
    }
}
