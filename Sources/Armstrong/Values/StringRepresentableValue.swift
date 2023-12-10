//
//  StringRepresentableValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 30/11/2023.
//

import Foundation

public protocol StringRepresentableValue {
    static var defaultValue: Self { get }
    init?(_ string: String)
}
