//
//  MakeableStack.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

public struct MakeableStackView: View {
    let isRunning: Bool
    let showEditControls: Bool
    let stack: MakeableStack
    
    let onContentUpdate: (MakeableStack) -> Void
    let onRuntimeUpdate: () -> Void
    
    @State var showAddIndex: Int?
    @State var showEditIndex: Int?
    @EnvironmentObject var variables: Variables
    @Binding var error: VariableValueError?
    
    public init(isRunning: Bool, showEditControls: Bool, stack: MakeableStack, onContentUpdate: @escaping (MakeableStack) -> Void, onRuntimeUpdate: @escaping () -> Void, showAddIndex: Int? = nil, showEditIndex: Int? = nil, error: Binding<VariableValueError?>) {
        self.isRunning = isRunning
        self.showEditControls = showEditControls
        self.stack = stack
        self.onContentUpdate = onContentUpdate
        self.onRuntimeUpdate = onRuntimeUpdate
        self.showAddIndex = showAddIndex
        self.showEditIndex = showEditIndex
        self._error = error
    }
    
    public var body: some View {
        Stack(axis: stack.content.axis.value) {
            if showEditControls {
                makeButton(at: 0)
            }
            
            if stack.content.value.isEmpty, !showEditControls {
                Text("STACK")
            } else {
                ForEach(enumerated: stack.content.value) { (index, element) in
                    HStack {
                        MakeableWrapperView(isRunning: isRunning, showEditControls: false, view: element, onContentUpdate: {
                            self.onUpdate(at: index, with: $0)
                        }, onRuntimeUpdate: onRuntimeUpdate, error: $error)
                        .onEdit(showEditControls ? { self.showEditIndex = index } : nil)
                        
                        if showEditControls {
                            ElementDeleteButton { onRemove(at: index) }
                        }
                    }
                    
                    if showEditControls {
                        makeButton(at: index + 1)
                    }
                }
            }
        }
        .if(showEditControls) {
            $0.padding().overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            )
        }
        .sheet(item: $showAddIndex, content: { index in
            AddViewView(viewModel: .init(onSelect: { view in
                stack.content = stack.content.inserting(view, at: index)
                onContentUpdate(stack)
                self.showAddIndex = nil
            }))
        }).sheet(item: $showEditIndex, content: { index in
            EditViewView(viewModel: .init(editable: stack.content.value[index]) {
                onUpdate(at: index, with: $0)
            })
        })
    }
    
    private func onRemove(at index: Int) {
        stack.content.value.remove(at: index)
        onContentUpdate(stack)
    }
    private func onUpdate(at index: Int, with value: any MakeableView) {
        stack.content.value[index] = value
        onContentUpdate(stack)
    }
    
    func makeButton(at index: Int) -> some View {
        SwiftUI.Button {
            showAddIndex = index
        } label: {
            Image(systemName: "plus.app.fill")
        }
    }
}

public final class MakeableStack: MakeableView, Codable {
    public static var type: VariableType { .stack }
    
    public var valueString: String { "STACK" }
    public var protoString: String { content.map { $0.protoString }.joined(separator: "\n") }
    
    public var content: MakeableArray
    
    public init(content: MakeableArray) {
        self.content = content
    }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        MakeableStack(
            content: try await content.value(with: variables)
        )
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue { fatalError() }
    
    public static func defaultValue(for property: Properties) -> any EditableVariableValue {
        switch property {
        case .content: return MakeableArray(value: [], axis: .init(value: .vertical))
        }
    }
    
    public func insertValues(into variables: Variables) async throws {
        for element in content {
            try await element.insertValues(into: variables)
        }
    }
}

extension MakeableStack: CodeRepresentable {
    public var codeRepresentation: String {
        return content.codeRepresentation
    }
}

extension MakeableStack {
    public convenience init(axis: Axis = .vertical, _ elements: [any MakeableView]) {
        self.init(content: .init(value: elements, axis: .init(value: axis)))
    }
}
