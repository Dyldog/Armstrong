//
//  MakeableStack.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

public struct MakeableStackView: View {
    let scope: Scope
    let isRunning: Bool
    let showEditControls: Bool
    let stack: MakeableStack
    
    let onContentUpdate: (MakeableStack) -> Void
    let onRuntimeUpdate: (@escaping Block) -> Void
    
    @State var showAddIndex: Int?
    @State var showEditIndex: Int?
    @EnvironmentObject var variables: Variables
    @Binding var error: VariableValueError?
    
//    @StateObject var elements: ArrayValue = .init(type: .string, elements: [])
//    var views: [HashableBox<any MakeableView>] {
//        elements.elements
//            .compactMap { $0 as? any MakeableView }
//            .enumerated()
//            .map { (offset, element) in .init(element, hash: { $0.encoded().string }) }
//    }
    
    public init(isRunning: Bool, showEditControls: Bool, scope: Scope, stack: MakeableStack, onContentUpdate: @escaping (MakeableStack) -> Void, onRuntimeUpdate: @escaping (@escaping Block) -> Void, showAddIndex: Int? = nil, showEditIndex: Int? = nil, error: Binding<VariableValueError?>) {
        self.isRunning = isRunning
        self.showEditControls = showEditControls
        self.stack = stack
        self.onContentUpdate = onContentUpdate
        self.onRuntimeUpdate = onRuntimeUpdate
        self.showAddIndex = showAddIndex
        self.showEditIndex = showEditIndex
        self._error = error
        self.scope = scope
    }
    
    private var content: ArrayValue {
        let variables = variables.copy()
        let elements: ArrayValue
        
        do {
            switch stack.content.value {
            case let .constant(array):
                elements = array
            default:
                if isRunning {
                    elements = try stack.content.value(with: variables, and: scope) as ArrayValue
                } else {
                    elements = .init(type: .label, elements: [MakeableLabel.withText(stack.content.protoString, multiline: true)])
                }
            }
        } catch let error as VariableValueError {
            self.error = error
            elements = .init(type: .label, elements: [MakeableLabel.withText("ERROR")])
        } catch {
            print(error)
            elements = .init(type: .label, elements: [MakeableLabel.withText("ERROR")])
        }
        
        return elements
    }
    
    public var body: some View {
        Stack(axis: stack.axis.value) {
            if showEditControls {
                makeButton(at: 0)
            }
            
            let elements = content.elements
            
            if elements.isEmpty == true, !showEditControls {
                Text("STACKs")
            } else {
                ForEach(enumerated: elements) { (index, element) in
                    HStack {
                        MakeableWrapperView(isRunning: isRunning, showEditControls: false, scope: scope, view: element as! (any MakeableView), onContentUpdate: {
                            self.onUpdate(at: index, with: $0)
                        }, onRuntimeUpdate: onRuntimeUpdate, error: $error)
                        .editable(showEditControls, onEdit: {
                            self.showEditIndex = index
                        }, onLongPress: {
                            UIPasteboard.general.copy(element)
                        })
                        
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
        .base(stack.base)
        .if(showEditControls) {
            $0.padding(4).overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
            )
        }
        .sheet(item: $showAddIndex, content: { index in
            AddViewView(viewModel: .init(onSelect: { view in
                guard let elements = stack.content.value.constant else { return }
                elements.elements.insert(view, at: index)
                stack.content = .value(elements)
                onContentUpdate(stack)
                self.showAddIndex = nil
            }))
        }).sheet(item: $showEditIndex, content: { index in
            let elements = stack.content.value.constant!
            NavigationView {
                EditViewView(title: "Elements", scope: scope, viewModel: .init(editable: elements.elements[index] as! (any MakeableView)) {
                    onUpdate(at: index , with: $0)
                })
            }
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
        LongPressButton {
            showAddIndex = index
        } longPressAction: {
            guard let view = UIPasteboard.general.pasteValue() as? (any MakeableView) else { return }
            guard let elements = stack.content.value.constant else { return }
            elements.elements.insert(view, at: index)
            stack.content = .value(elements)
            onContentUpdate(stack)
        } label: {
            Image(systemName: "plus.app.fill")
        }
        .padding(4)
        .foregroundStyle(.blue)
    }
}

public final class MakeableStack: MakeableView, Codable, ObservableObject {
    public static var type: VariableType { .stack }
    
    public let id: UUID
    
    public var valueString: String { "STACK" }
    public var protoString: String { "STACK(\(content.protoString))" }
    
    @Published public var base: MakeableBase
    @Published public var axis: AxisValue
    @Published public var content: TypedValue<ArrayValue>
    
    public init(id: UUID, base: MakeableBase = .makeDefault(), axis: AxisValue = .init(value: .vertical), content: TypedValue<ArrayValue>) {
        self.id = id
        self.base = base
        self.content = content
        self.axis = axis
    }
    
    public convenience init(id: UUID, base: MakeableBase = .makeDefault(), axis: AxisValue = .init(value: .vertical), elements: ArrayValue) {
        self.init(id: id, base: base, axis: axis, content: .value(elements))
    }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        MakeableStack(
            id: id,
            base: try base.value(with: variables, and: scope),
            axis: try axis.value(with: variables, and: scope),
            content: .value(try content.value(with: variables, and: scope))
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
    
    public func insertValues(into variables: Variables, with scope: Scope) throws {
        for element in content.value.constant?.elements ?? [] {
            guard let element = element as? (any MakeableView) else { return }
            try element.insertValues(into: variables, with: scope)
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
            id: .init(),
            base: .makeDefault(),
            axis: .init(value: axis),
            content: .value(.init(type: .base, elements: elements))
        )
    }
}
