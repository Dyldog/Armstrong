//
//  MakeableWrapperView.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import SwiftUI
import DylKit

public struct MakeableWrapperView: View {
    let showEditControls: Bool
    let view: any MakeableView
    let onContentUpdate: (any MakeableView) -> Void
    let onRuntimeUpdate: (@escaping Block) -> Void
    let scope: Scope
    @Binding var error: VariableValueError?
    
    public init(showEditControls: Bool, scope: Scope, view: any MakeableView, onContentUpdate: @escaping (any MakeableView) -> Void, onRuntimeUpdate: @escaping (@escaping Block) -> Void, error: Binding<VariableValueError?>) {
        self.showEditControls = showEditControls
        self.view = view
        self.onContentUpdate = onContentUpdate
        self.onRuntimeUpdate = onRuntimeUpdate
        self._error = error
        self.scope = scope
    }
    
    public var body: some View {
        Self._printChanges()
        return inner
    }
    
    var inner: some View {
        view.make(
            showEditControls: showEditControls, 
            scope: scope,
            onContentUpdate: onContentUpdate,
            onRuntimeUpdate: onRuntimeUpdate,
            error: $error
        )
        
    }
}
