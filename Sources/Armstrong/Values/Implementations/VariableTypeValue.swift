//
//  File.swift
//  
//
//  Created by Dylan Elliott on 14/12/2023.
//

import SwiftUI
import DylKit

// sourcery: variableTypeName = "type"
public final class VariableTypeValue: PrimitiveEditableVariableValue {
    
    public static let categories: [ValueCategory] = [.helperValues]
    public static var type: VariableType { .type }
    public var value: VariableType
    
    public var protoString: String { value.protoString }
    
    public var valueString: String { value.valueString }
    
    public init(value: VariableType) {
        self.value = value
    }
    
    public static func makeDefault() -> VariableTypeValue {
        .init(value: .string)
    }
    
    public func value(with variables: Variables, and scope: Scope) throws -> VariableValue {
        self
    }
    
    public func add(_ other: VariableValue) throws -> VariableValue {
        fatalError()
    }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (VariableTypeValue) -> Void) -> AnyView {
        value.editView(scope: scope, title: title) { [weak self] in
            guard let self = self else { return }
            self.value = $0
            onUpdate(self)
        }
    }
    
}
extension VariableType {

    public var valueString: String { protoString }
    
    public func editView(scope: Scope, title: String, onUpdate: @escaping (VariableType) -> Void) -> AnyView {
        TypePickerButton(valueString: valueString, elements: AALibrary.shared.values) {
            onUpdate($0.type)
        }
        .scope(scope)
        .any
        
//        Picker("", selection: .init(get: {
//            self
//        }, set: { new in
//            onUpdate(new)
//        })) {
//            ForEach(AALibrary.shared.values) {
//                Text($0.type.title).tag($0.type)
//            }
//        }
//        .pickerScope(scope)
//        .any
    }
}

typealias CategoryValue = EditableVariableValue.Type

extension ValueCategoryGroup {
    
    func categoryLineage(child: CategoryPickerItem<CategoryValue>?) -> CategoryPickerItem<CategoryValue> {
        switch parent {
        case .none: return categoryItem(child: child)
        case let .some(parent): return parent.categoryLineage(child: categoryItem(child: child))
        }
    }
    
    func categoryItem(child: CategoryPickerItem<CategoryValue>?) -> CategoryPickerItem<CategoryValue> {
        if let child, child.title == title {
            return child
        } else {
            return CategoryPickerItem(
                id: id,
                title: title,
                image: icon,
                value: .children([child].compactMap { $0 })
            )
        }
    }
}

extension ValueCategory {
    func categoryLineage(with type: EditableVariableValue.Type) -> CategoryPickerItem<EditableVariableValue.Type> {
        parent.categoryLineage(child:
            CategoryPickerItem(
                id: id,
                title: title,
                image: icon,
                value: .children([
                    .init(
                        id: "\(id)-\(type.type.title.sluggified)",
                        title: type.type.title,
                        image: nil,
                        value: .value(type)
                    )
                ])
            )
        )
    }
}
extension Array where Element == CategoryValue {
    
    private func combine(tree: CategoryPickerItem<CategoryValue>, with branch: CategoryPickerItem<CategoryValue>) -> CategoryPickerItem<CategoryValue>? {
        guard 
            branch.id.hasPrefix(tree.id), case let .children(array) = tree.value,
            case let .children(branchChildren) = branch.value, branchChildren.count == 1, let nextBranch = branchChildren.first
        else {  return nil }
           
        func makeReplacement(newChildren: [CategoryPickerItem<CategoryValue>]) -> CategoryPickerItem<CategoryValue> {
            .init(
                id: tree.id,
                title: tree.title,
                image: tree.image,
                value: .children(newChildren)
            )
        }
        
        for (index, child) in array.enumerated() {
            if let combined = combine(tree: child, with: nextBranch) {
                return makeReplacement(newChildren: array.replacing(combined, at: index))
            }
        }
        
        switch branch.value {
        case let .children(branchChildren): return makeReplacement(newChildren: array + branchChildren)
        case .value: return makeReplacement(newChildren: array + [branch])
        }
    }
    
    var categoryTree: [CategoryPickerItem<CategoryValue>] {
        var tree: CategoryPickerItem<CategoryValue> = ValueCategoryGroup.root.categoryLineage(child: nil)
        
        forEach { element in
            element.categories.forEach { category in
                guard let newTree = combine(
                    tree: tree,
                    with: category.categoryLineage(with: element)
                ) else {
                    fatalError()
                }
                                
                tree = newTree
            }
        }
        
        guard case let .children(array) = tree.value else { fatalError() }
        return array
    }
}

struct TypePickerButton: View {
    @State var showSheet = false
    var valueString: String
    let elements: [any EditableVariableValue.Type]
    let onUpdate: (any EditableVariableValue.Type) -> Void
    
    var body: some View {
        SheetButton(showSheet: $showSheet, title: { Text(valueString) }) {
            NavigationView {
                CategoryPicker(title: "Select Type", elements: elements.categoryTree) { item in
                    onUpdate(item)
                    showSheet = false
                }
            }
        }
    }
}
