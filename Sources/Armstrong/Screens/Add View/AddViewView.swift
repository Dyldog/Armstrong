//
//  AddViewView.swift
//  AppApp
//
//  Created by Dylan Elliott on 20/11/2023.
//

import SwiftUI
import DylKit

public struct AddViewView: View {
    let onSelect: (any MakeableView) -> Void
    
    public init(onSelect: @escaping (any MakeableView) -> Void) {
        self.onSelect = onSelect
    }
    
    public var body: some View {
        NavigationView {
            CategoryPicker(title: "Select View", elements: (AALibrary.shared.views as [any EditableVariableValue.Type]).categoryTree) {
                onSelect($0.makeDefault() as! (any MakeableView))
            }
        }
//        List {
//            ForEach(viewModel.rows, id: \.title) { item in
//                SwiftUI.Button(item.title) {
//                    item.onTap()
//                }
//                .buttonStyle(.plain)
//            }
//        }
    }
}
