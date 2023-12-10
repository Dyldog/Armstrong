//
//  MakeableView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

public protocol MakeableView: CompositeEditableVariableValue, Codable, CodeRepresentable {
    func insertValues(into variables: Variables) async throws
    func make(isRunning: Bool, showEditControls: Bool, onContentUpdate: @escaping (any MakeableView) -> Void, onRuntimeUpdate: @escaping () -> Void, error: Binding<VariableValueError?>) -> AnyView
}
