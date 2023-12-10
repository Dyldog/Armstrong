//
//  ElementDeleteButton.swift
//  AppApp
//
//  Created by Dylan Elliott on 30/11/2023.
//

import SwiftUI

public struct ElementDeleteButton: View {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 6)
                .padding(4)
                .background(
                    Circle()
                        .foregroundStyle(.gray).brightness(-0.05)
                )
                .foregroundStyle(.white.opacity(0.8))
                .padding(4)
        }
    }
}

#Preview {
    ElementDeleteButton(action: { })
}
