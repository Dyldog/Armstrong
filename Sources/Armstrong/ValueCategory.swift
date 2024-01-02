//
//  File.swift
//  
//
//  Created by Dylan Elliott on 30/12/2023.
//

import SwiftUI

public struct ValueCategoryGroup {
    var parent: Parent
    var iconName: String
    var title: String
    var icon: Image { .init(systemName: iconName) }
    
    var id: String { "\(parent.id)-\(title.sluggified)" }
    
    public indirect enum Parent {
        case none
        case some(ValueCategoryGroup)
        
        var id: String {
            switch self {
            case .none: return "-"
            case let .some(category): return category.id
            }
        }
    }
    
    public init(parent: Parent, iconName: String, title: String) {
        self.parent = parent
        self.iconName = iconName
        self.title = title
    }
}

extension ValueCategoryGroup {
    public var topLevel: ValueCategory {
        .init(
            parent: self,
            iconName: iconName,
            title: title
        )
    }
    
    public var helpers: ValueCategory {
        .init(
            parent: self,
            iconName: "hand.raised",
            title: "Helpers"
        )
    }
}

public struct ValueCategory {
    let parent: ValueCategoryGroup
    let iconName: String
    let title: String
    
    var id: String { "\(parent.id)-\(title.sluggified)" }
    
    var icon: Image { .init(systemName: iconName) }
    
    public init(parent: ValueCategoryGroup, iconName: String, title: String) {
        self.parent = parent
        self.iconName = iconName
        self.title = title
    }
}

public extension String {
    var sluggified: String {
        lowercased().components(separatedBy: .alphanumerics.inverted).joined()
    }
}
