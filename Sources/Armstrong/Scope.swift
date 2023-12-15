//
//  File.swift
//  
//
//  Created by Dylan Elliott on 15/12/2023.
//

import Foundation
import SwiftUI

public struct Scope {
    private let index: Int
    
    var color: Color { .forScope(index) }
    
    private init(index: Int) {
        self.index = index
    }
    
    public init() {
        self.init(index: 0)
    }
    
    public var next: Scope {
        .init(index: index + 1)
    }
}

extension View {
    func scope(_ scope: Scope) -> some View {
        self
            .tint(scope.color)
            .foregroundStyle(scope.color)
    }
}

extension View {
    func pickerScope(_ scope: Scope) -> some View {
        self
            .accentColor(scope.color)
    }
}
