//
//  AddActionView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

struct AddActionView: View {
    @State var searchText: String = ""
    let onSelect: (any StepType) -> Void
    
//    var actions: [Actions] {
//        guard !searchText.isEmpty else { return Actions.allCases }
//        return Actions.allCases.filter { $0.title.lowercased().contains(searchText.lowercased()) }
//    }
    
    var body: some View {
        Text("TODO")
//        NavigationView {
//            List(actions, id: \.self) { item in
//                SwiftUI.Button(item.title) {
//                    onSelect(item.make())
//                }
//            }
//            .navigationTitle("Add Action")
//            .searchable(text: $searchText)
//        }
    }
}
