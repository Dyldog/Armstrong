//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import Foundation

public extension CompositeEditableVariableValue {
    func propertyRows(
        onUpdate: @escaping (Self) -> Void
    ) -> [(String, any EditableVariableValue, VariableUpdater)] {
        properties.flatMap { (key, value) in
//            if let composite = value as? any CompositeEditableVariableValue {
//                return composite.propertyRows(onUpdate: { value in
//                    self.set(value, for: key)
//                    onUpdate(self)
//                })
//            } else if let primitive = value as? any PrimitiveEditableVariableValue {
//                return [(key.rawValue, primitive, {
//                    self.set($0, for: key)
//                    onUpdate(self)
//                })]
//            } else {
                return [(key.rawValue, value, {
                    self.set($0, for: key)
                    onUpdate(self)
                })]
//            }
        }.sorted(by: { $0.0 < $1.0 })
    }
}

import SwiftUI

struct ExpandableValueView<T: EditableVariableValue>: View {
    
    let title: String
    let value: T
    let onUpdate: (T) -> Void
    var body: some View {
        ExpandableStack(title: title) {
            HStack {
                Text(value.protoString)
            }
        } content: {
            value.editView(title: title) { value in
                onUpdate(value)
            }.multilineTextAlignment(.trailing)
        }
    }
}
