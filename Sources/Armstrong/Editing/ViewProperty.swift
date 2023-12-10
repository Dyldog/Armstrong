//
//  ViewProperty.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import Foundation

public protocol ViewProperty: RawRepresentable, CaseIterable, Hashable where RawValue == String {
    var defaultValue: any EditableVariableValue { get }
}
