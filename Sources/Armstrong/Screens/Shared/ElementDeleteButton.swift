//
//  ElementDeleteButton.swift
//  AppApp
//
//  Created by Dylan Elliott on 30/11/2023.
//

import SwiftUI

public struct ElementDeleteButton: View {
    let action: () -> Void
    let color: Color
    
    public init(color: Color = .gray, action: @escaping () -> Void) {
        self.color = color
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
                        .foregroundStyle(color)
                )
                .foregroundStyle(.white.opacity(0.8))
                .padding(.vertical, 4)
                .padding(.leading, 4)
                .fixedSize()
        }
    }
}

#Preview {
    ElementDeleteButton(action: { })
}
