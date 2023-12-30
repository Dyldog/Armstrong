//
//  File.swift
//  
//
//  Created by Dylan Elliott on 18/12/2023.
//

import SwiftUI
import DylKit

public struct MakeableScreenView: View {
    let showEditControls: Bool
    let scope: Scope
    let screen: ScreenValue
    
    let onContentUpdate: (ScreenValue) -> Void
    let onRuntimeUpdate: (@escaping Block) -> Void
    
    @EnvironmentObject var variables: OptionalBox<Variables>
    @Binding var error: VariableValueError?
    
//    @State var content: MakeableStack?
    
    public init(showEditControls: Bool, scope: Scope, screen: ScreenValue, onContentUpdate: @escaping (ScreenValue) -> Void, onRuntimeUpdate: @escaping (@escaping Block) -> Void, error: Binding<VariableValueError?>) {
        self.showEditControls = showEditControls
        self.screen = screen
        self.onContentUpdate = onContentUpdate
        self.onRuntimeUpdate = onRuntimeUpdate
        self._error = error
        self.scope = scope
    }
    
    private var content: some View {
        do {
            if variables.hasValue {
                let stack: MakeableStack = try screen.value(with: $variables.unwrapped, and: scope)
                let variableDict: DictionaryValue = try screen.arguments.value(with: $variables.unwrapped, and: scope)
//                variables.value?.set(from: variableDict)
                return MakeableWrapperView(
                    showEditControls: showEditControls,
                    scope: scope,
                    view: try stack.value(with: $variables.unwrapped, and: scope),
                    onContentUpdate: { _ in
                        fatalError()
                    },
                    onRuntimeUpdate: onRuntimeUpdate,
                    error: $error
                ).any
            } else {
                return Text(screen.protoString).any
            }
        } catch {
            print(error)
            return Text("ERROR").any
        }
    }
    
    public var body: some View {
        content
    }
}
