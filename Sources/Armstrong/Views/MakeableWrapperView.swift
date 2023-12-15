//
//  MakeableWrapperView.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import SwiftUI

public struct MakeableWrapperView: View {
    let isRunning: Bool
    let showEditControls: Bool
    var view: any MakeableView
    let onContentUpdate: (any MakeableView) -> Void
    let onRuntimeUpdate: () -> Void
    @Binding var error: VariableValueError?
    
    public init(isRunning: Bool, showEditControls: Bool, view: any MakeableView, onContentUpdate: @escaping (any MakeableView) -> Void, onRuntimeUpdate: @escaping () -> Void, error: Binding<VariableValueError?>) {
        self.isRunning = isRunning
        self.showEditControls = showEditControls
        self.view = view
        self.onContentUpdate = onContentUpdate
        self.onRuntimeUpdate = onRuntimeUpdate
        self._error = error
    }
    
    public var body: some View {
        ZStack {
            inner
        }
    }
    
    var inner: some View {
        view.make(
            isRunning: isRunning,
            showEditControls: showEditControls,
            onContentUpdate: onContentUpdate,
            onRuntimeUpdate: onRuntimeUpdate,
            error: $error
        )
        
    }
}
