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
    @ObservedObject var stack: MakeableStack
    
    let onContentUpdate: (MakeableStack) -> Void
    let onRuntimeUpdate: () -> Void
    
    @State var showAddIndex: Int?
    @State var showEditIndex: Int?
    @EnvironmentObject var variables: Variables
    @Binding var error: VariableValueError?
    
    @State var elements: [any MakeableView]?
    
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
        Stack(axis: stack.axis.value) {
            if showEditControls {
                makeButton(at: 0)
            }
            
            if elements?.isEmpty == true, !showEditControls {
                Text("STACKs")
            } else {
                ForEach(enumerated: elements ?? []) { (index, element) in
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
        .task(id: variables.hashValue) {
            do {
                switch stack.content.value {
                case let .constant(array):
                    self.elements = array.elements.compactMap { $0 as! (any MakeableView) }
                default:
                    if isRunning {
                        self.elements = (try await stack.content.value(with: variables) as ArrayValue).elements.compactMap { $0 as? any MakeableView }
                    } else {
                        self.elements = [
                            MakeableLabel.withText(stack.content.protoString, multiline: true)
                        ]
                    }
                }
            } catch let error as VariableValueError {
                self.error = error
            } catch {
                print(error)
            }
        }
        .base(stack.base)
        .if(showEditControls) {
            $0.padding().overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            )
        }
        .sheet(item: $showAddIndex, content: { index in
            AddViewView(viewModel: .init(onSelect: { view in
                guard let elements = stack.content.value.constant else { return }
                elements.elements.append(view)
                stack.content = .value(elements)
                onContentUpdate(stack)
                self.showAddIndex = nil
            }))
        }).sheet(item: $showEditIndex, content: { index in
            let elements = stack.content.value.constant!
            EditViewView(viewModel: .init(editable: elements.elements[index] as! (any MakeableView)) {
                onUpdate(at: index, with: $0)
            })
        })
    }
    
    private func onRemove(at index: Int) {
        guard let elements = stack.content.value.constant else { return }
        elements.elements.remove(at: index)
        stack.content = .value(elements)
        onContentUpdate(stack)
    }
    private func onUpdate(at index: Int, with value: any MakeableView) {
        guard let elements = stack.content.value.constant else { return }
        elements.elements[index] = value
        stack.content = .value(elements)
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

public final class MakeableStack: MakeableView, Codable, ObservableObject {
    public static var type: VariableType { .stack }
    
    public var valueString: String { "STACK" }
    public var protoString: String { "STACK(\(content.protoString))" }
    
    public var base: MakeableBase { willSet { objectWillChange.send() } }
    public var axis: AxisValue { willSet { objectWillChange.send() } }
    public var content: TypedValue<ArrayValue> { willSet { objectWillChange.send() } }
    
    public init(base: MakeableBase = .makeDefault(), axis: AxisValue = .init(value: .vertical), content: TypedValue<ArrayValue>) {
        self.base = base
        self.content = content
        self.axis = axis
    }
    
    public convenience init(base: MakeableBase = .makeDefault(), axis: AxisValue = .init(value: .vertical), elements: ArrayValue) {
        self.init(base: base, axis: axis, content: .value(elements))
    }
    
    public func value(with variables: Variables) async throws -> VariableValue {
        MakeableStack(
            base: try await base.value(with: variables),
            axis: try await axis.value(with: variables),
            content: .value(try await content.value(with: variables))
        )
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue { fatalError() }
    
    public static func defaultValue(for property: Properties) -> any EditableVariableValue {
        switch property {
        case .content:
            return TypedValue.value(ArrayValue(type: .base, elements: []))
        case .base:
            return MakeableBase.makeDefault()
        case .axis:
            return AxisValue(value: .vertical)
        }
    }
    
    public func insertValues(into variables: Variables) async throws {
        for element in try content.value.constant?.elements ?? [] {
            guard let element = element as? (any MakeableView) else { return }
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
        self.init(
            base: .makeDefault(),
            axis: .init(value: axis),
            content: .value(.init(type: .base, elements: elements))
        )
    }
}
