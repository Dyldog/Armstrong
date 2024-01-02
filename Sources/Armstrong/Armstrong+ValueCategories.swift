//
//  File.swift
//  
//
//  Created by Dylan Elliott on 30/12/2023.
//

import Foundation

private enum Images {
    static let container = "shippingbox"
    static let logic = "brain"
    static let numbers = "function"
}

public extension ValueCategoryGroup {
    static let root: ValueCategoryGroup = .init(parent: .none, iconName: "", title: "ROOT")
}

public extension ValueCategory {
    static let helperValues: ValueCategory = .init(parent: .root, iconName: "hand.raised", title: "Helpers")
}

public extension ValueCategory {
    static let computation: ValueCategory = .init(parent: .root, iconName: "desktopcomputer.and.arrow.down", title: "Computation")
}

public extension ValueCategory {
    static let containers: ValueCategory = .init(parent: .root, iconName: Images.container, title: "Containers")
}

public extension ValueCategoryGroup {
    static let logic: ValueCategoryGroup = .init(parent: .some(root), iconName: Images.logic, title: "Logic")
}
public extension ValueCategory {
    static let logic: ValueCategory = ValueCategoryGroup.logic.topLevel
    static let logicHelpers: ValueCategory = ValueCategoryGroup.logic.helpers
}

public extension ValueCategory {
    static let visual: ValueCategory = .init(parent: .root, iconName: "eye", title: "Visual")
}

// MARK: - Numbers

public extension ValueCategory {
    static let numbers: ValueCategory = .init(parent: .root, iconName: Images.numbers, title: "Numbers")
}

// MARK: - Location

public extension ValueCategory {
    static let location: ValueCategory = .init(parent: .root, iconName: "location.fill", title: "Location")
}

// MARK: - Text

public extension ValueCategory {
    static let text: ValueCategory = .init(parent: .root, iconName: "textformat.abc", title: "Text")
}

// MARK: - UI

public extension ValueCategoryGroup {
    static let ui: ValueCategoryGroup = .init(parent: .some(root), iconName: "iphone", title: "UI")
}

// MARK: Values

public extension ValueCategory {
    static let layout: ValueCategory = .init(parent: .ui, iconName: "list.bullet.indent", title: "Layout")
}

// MARK: Views

public extension ValueCategoryGroup {
    static let views: ValueCategoryGroup = .init(parent: .some(ui), iconName: "viewfinder", title: "Views")
}

public extension ValueCategory {
    static let views: ValueCategory = ValueCategoryGroup.views.topLevel
}

public extension ValueCategory {
    static let helperViews: ValueCategory = ValueCategoryGroup.views.helpers
}

// MARK: - Steps

public extension ValueCategoryGroup {
    static let steps: ValueCategoryGroup = .init(parent: .some(root), iconName: "figure.walk", title: "Steps")
}

public extension ValueCategory {
    static let variables: ValueCategory = .init(parent: .steps, iconName: "character.textbox", title: "Variables")
    
    static let network: ValueCategory = .init(parent: .steps, iconName: "globe", title: "Network")
    
    static let containerSteps: ValueCategory = .init(parent: .steps, iconName: Images.container, title: "Containers")
    
    static let dataProcessing: ValueCategory = .init(parent: .steps, iconName: "antenna.radiowaves.left.and.right", title: "Data")
    
    static let looping: ValueCategory = .init(parent: .steps, iconName: "clock.arrow.2.circlepath", title: "Looping")
    
    static let logicSteps: ValueCategory = .init(parent: .steps, iconName: Images.logic, title: "Logic")
    
    static let numberSteps: ValueCategory = .init(parent: .steps, iconName: Images.numbers, title: "Numbers")
}


