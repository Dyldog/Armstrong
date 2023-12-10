//
//  CodableStep.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import Foundation

struct CodableStep {
    let value: any StepType
    let type: String
    
    init(value: any StepType) {
        self.value = value
        self.type = typeString(Swift.type(of: value))
    }
}

extension CodableStep: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodedType = try valueContainer.decode(String.self, forKey: .type)
        
        for viewType in AALibrary.shared.steps {
            if typeString(viewType) == decodedType {
                self.type = decodedType
                self.value = try valueContainer.decode(viewType, forKey: .value)
                return
            }
        }
        
        fatalError()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
    }
}
