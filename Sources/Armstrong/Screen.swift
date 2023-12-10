//
//  Screen.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import Foundation
import DylKit
import SwiftUI

public struct Screen: Codable, Identifiable {
    @UserDefaultable(key: "SCREENS") public static var screens: [Screen] = []
    
    public let id: UUID
    public var name: String
    public var initActions: StepArray
    public var content: MakeableStack
    
    enum CodingKeys: String, CodingKey {
        case initActions
        case content
        case id
        case name
    }
    
    public init(id: UUID, name: String, initActions: StepArray, content: MakeableStack) {
        self.name = name
        self.id = id
        self.initActions = initActions
        self.content = content
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(initActions, forKey: .initActions)
        try container.encode(content, forKey: .content)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        initActions = try container.decode(StepArray.self, forKey: .initActions)
        content = try container.decode(MakeableStack.self, forKey: .content)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
    }
}
