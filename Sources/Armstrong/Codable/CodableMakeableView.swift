//
//  CodableMakeableView.swift
//  AppApp
//
//  Created by Dylan Elliott on 29/11/2023.
//

import Foundation

public struct CodableMakeableView {
    public let type: String
    public let value: any MakeableView
    
    public init(value: any MakeableView) {
        self.value = value
        self.type = typeString(Swift.type(of: value))
    }
}

extension CodableMakeableView: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    public init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodedType = try valueContainer.decode(String.self, forKey: .type)
        
        for viewType in AALibrary.shared.views {
            if typeString(viewType) == decodedType {
                self.type = decodedType
                self.value = try valueContainer.decode(viewType, forKey: .value)
                return
            }
        }
        
        fatalError()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
    }
}
