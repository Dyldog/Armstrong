//
//  AddViewView.swift
//  AppApp
//
//  Created by Dylan Elliott on 20/11/2023.
//

import SwiftUI

public struct AddViewView: View {
    @StateObject var viewModel: AddViewViewModel
    
    public init(viewModel: AddViewViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        List {
            ForEach(viewModel.rows, id: \.title) { item in
                SwiftUI.Button(item.title) {
                    item.onTap()
                }
                .buttonStyle(.plain)
            }
        }
    }
}
