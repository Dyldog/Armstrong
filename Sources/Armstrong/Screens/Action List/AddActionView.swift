//
//  AddActionView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

struct AddActionView: View {
    @State var searchText: String = ""
    let onSelect: (any StepType) -> Void
    
    var body: some View {
        NavigationView {
            List(AALibrary.shared.steps.map { HashableBox($0, hash: { $0.type })}, id: \.self) { item in
                SwiftUI.Button(item.value.title) {
                    onSelect(item.value.makeDefault())
                }
            }
            .navigationTitle("Add Action")
            .searchable(text: $searchText)
        }
    }
}
