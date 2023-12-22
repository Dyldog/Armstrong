//
//  MakeableView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

public protocol MakeableView: CompositeEditableVariableValue, Codable, CodeRepresentable, ObservableObject, Identifiable where ID == UUID {
    func insertValues(into variables: Variables, with scope: Scope) throws
    func make(isRunning: Bool, showEditControls: Bool, scope: Scope, onContentUpdate: @escaping (any MakeableView) -> Void, onRuntimeUpdate: @escaping (@escaping Block) -> Void, error: Binding<VariableValueError?>) -> AnyView
}
