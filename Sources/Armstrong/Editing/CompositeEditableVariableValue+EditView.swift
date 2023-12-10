//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import SwiftUI
import DylKit

public extension CompositeEditableVariableValue {
    func editView(title: String, onUpdate: @escaping (Self) -> Void) -> AnyView {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(enumerated: propertyRows(onUpdate: onUpdate).map { ($0.0, $0.1, $0.2) }) { (index, row) in
                HStack {
                    Text(row.0.titleCase()).bold()
                    Spacer()
                    row.1.editView(title: row.0) { value in
                        row.2(value)
                        onUpdate(self)
                    }.multilineTextAlignment(.trailing)
                }
            }
        }.any
    }
}
