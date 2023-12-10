//
//  AddViewViewModel.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

public struct AddViewRow {
    public let title: String
    public let onTap: () -> Void
    
    public init(title: String, onTap: @escaping () -> Void) {
        self.title = title
        self.onTap = onTap
    }
}

extension AddViewViewModel {
    convenience init(onSelect: @escaping (any MakeableView) -> Void) {
        self.init(rows: AALibrary.shared.views.map { viewType in
            .init(title: viewType.type.title, onTap: {
                onSelect(viewType.makeDefault())
            })
        })
    }
}

public class AddViewViewModel: ObservableObject {
    let rows: [AddViewRow]
    
    public init(rows: [AddViewRow]) {
        self.rows = rows
    }
}
