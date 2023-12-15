//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import SwiftUI

public extension PrimitiveEditableVariableValue {
    func editView(scope: Scope, title: String, onUpdate: @escaping (Self) -> Void) -> AnyView {
        HStack {
            Text(title).bold().scope(scope)
            Spacer()
            Picker("", selection: .init(get: { [weak self] in
                self?.value ?? Self.makeDefault().value
            }, set: { [weak self] new in
                guard let self = self else { return }
                self.value = new
                onUpdate(self)
            })) {
                ForEach(Primitive.allCases) {
                    Text($0.title).tag($0)
                }
            }
            .pickerScope(scope)
        }
        .scope(scope)
        .any
    }
}
