//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import Foundation

public protocol PickableValue: CaseIterable, Titleable, Codable, CodeRepresentable {
    static var defaultValue: Self { get }
}
