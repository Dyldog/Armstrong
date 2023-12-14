//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import Foundation

public struct VariableType: CaseIterable, Equatable, Codable, Titleable, CodeRepresentable, Hashable {
    
    public static var allCases: [VariableType] { AALibrary.shared.values.map { $0.type } }
    
    public let title: String
    
    public var codeRepresentation: String { title }
        
    public var protoString: String { title }
    
    public init(title: String) {
        self.title = title
    }
}

extension VariableType {
    public var editableType: (any EditableVariableValue.Type)? {
        AALibrary.shared.values.first(where: { $0.type == self })
    }
}
