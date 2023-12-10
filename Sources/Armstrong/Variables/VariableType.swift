//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import Foundation

public struct VariableType: CaseIterable, Equatable, Codable, Titleable, CodeRepresentable, Hashable {

    public static var allCases: [VariableType] = []
    
    public var title: String = "TODO"
    
    public init() { }
    
    public var codeRepresentation: String { "TODO" }
    
    public var defaultView: any EditableVariableValue { fatalError() }
}
