//
//  MakeableArray.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import SwiftUI

//// sourcery: variableTypeName = "makeableArray"
//public final class MakeableArray: EditableVariableValue {
//
//    public static var type: VariableType { .makeableArray }
//    public static var defaultValue: MakeableArray { .init(value: [], axis: .init(value: .vertical))}
//    
//    public var protoString: String { "TODO" }
//    public var valueString: String { "TODO" }
//    
//    
//    public var value: [any MakeableView]
//    public var axis: AxisValue
//    
//    public init(value: [any MakeableView], axis: AxisValue) {
//        self.value = value
//        self.axis = axis
//    }
//    
//    public static func makeDefault() -> MakeableArray {
//        .init(
//            value: [any MakeableView](),
//            axis: .init(value: .vertical)
//        )
//    }
//    
//    public func add(_ other: VariableValue) throws -> VariableValue {
//        fatalError()
//    }
//    
//    public func value(with variables: Variables, and scope: Scope) async throws -> VariableValue {
//        var newViews: [any MakeableView] = []
//        
//        for view in value {
//            newViews.append(try await view.value(with: variables))
//        }
//        
//        return MakeableArray(
//            value: newViews,
//            axis: try await axis.value(with: variables)
//        )
//    }
//    
//    
//    public func editView(title: String, onUpdate: @escaping (MakeableArray) -> Void) -> AnyView {
//        VStack {
//            axis.editView(title: "\(title)[axis]") {
//                self.axis = $0
//                onUpdate(self)
//            }
//            MakeableStackView(
//                isRunning: false,
//                showEditControls: true,
//                stack: .init(base: .makeDefault(), content: .value(self)),
//                onContentUpdate: {
//                    guard let value = $0.content.value.constant else { return }
//                    onUpdate(value)
//                },
//                onRuntimeUpdate: { }, 
//                error: .constant(nil)
//            )
//        }.any
//    }
//}
//
//extension MakeableArray: Codable {
//    enum CodingKeys: String, CodingKey {
//        case value
//        case axis
//    }
//    
//    public convenience init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.init(
//            value: try container.decode(CodableMakeableList.self, forKey: .value).elements.map { $0.value },
//            axis: try container.decode(AxisValue.self, forKey: .axis)
//        )
//    }
//    
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(CodableMakeableList(elements: value), forKey: .value)
//        try container.encode(axis, forKey: .axis)
//    }
//    
//    public func inserting(_ value: Element, at index: Int) -> Self {
//        .init(value: self.value.inserting(value, at: index), axis: axis)
//    }
//    
//    public func removing(at index: Int) -> Self {
//        .init(value: value.removing(at: index), axis: axis)
//    }
//}
//
//extension MakeableArray: Sequence {
//    public func makeIterator() -> IndexingIterator<[any MakeableView]> {
//        IndexingIterator(_elements: value)
//    }
//}
//
//extension MakeableArray: CodeRepresentable {
//    private var stackType: String {
//        switch axis.value {
//        case .vertical: return "VStack"
//        case .horizontal: return "HStack"
//        }
//    }
//    
//    public var codeRepresentation: String {
//        """
//        \(stackType) {
//        \(value.map { "\t" + $0.codeRepresentation }.joined(separator: "\n"))
//        }
//        """
//    }
//}
