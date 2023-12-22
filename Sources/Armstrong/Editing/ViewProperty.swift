//
//  ViewProperty.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import Foundation

public protocol ViewProperty: Hashable {
    static var allCases: [Self] { get }
    var rawValue: String { get }
    var defaultValue: any EditableVariableValue { get }
}
