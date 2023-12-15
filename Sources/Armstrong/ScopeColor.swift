//
//  File.swift
//  
//
//  Created by Dylan Elliott on 15/12/2023.
//

import DylKit
import SwiftUI

enum ScopeColour {
    static subscript(_ index: Int) -> Color {
        Color.rainbowColors[looping: index]
    }
}

extension Color {
    static func forScope(_ index: Int) -> Color {
        ScopeColour[index]
    }
}
