//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import SwiftUI

extension PrimitiveEditableVariableValue {
    func editView(title: String, onUpdate: @escaping (Self) -> Void) -> AnyView {
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
        }.pickerStyle(.menu).any
    }
}
