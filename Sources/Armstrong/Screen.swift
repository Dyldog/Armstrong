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
    
    @UserDefaultable(key: "SCREENS", store: UserDefaults.appApp) public static var screens: [Screen] = []
    
    enum CodingKeys: String, CodingKey {
        case initVariables
        case initActions
        case content
        case id
        case name
        case subscreens
    }
    
    public let id: UUID
    public var name: String
    
    public var initVariables: DictionaryValue
    public var initActions: StepArray
    public var content: MakeableStack
    public var subscreens: [Screen]
    
    public init(id: UUID, name: String, initVariables: DictionaryValue, initActions: StepArray, subscreens: [Screen], content: MakeableStack) {
        self.name = name
        self.id = id
        self.initActions = initActions
        self.initVariables = initVariables
        self.content = content
        self.subscreens = subscreens
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(initVariables, forKey: .initVariables)
        try container.encode(initActions, forKey: .initActions)
        try container.encode(content, forKey: .content)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(subscreens, forKey: .subscreens)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        initVariables = (try? container.decode(DictionaryValue.self, forKey: .initVariables)) ?? .makeDefault()
        initActions = try container.decode(StepArray.self, forKey: .initActions)
        content = try container.decode(MakeableStack.self, forKey: .content)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        subscreens = (try? container.decode([Screen].self, forKey: .subscreens)) ?? []
    }
}

extension Screen {
    func initialise(with vars: Variables, and scope: Scope, useInputVarsForInit: Bool = false) async throws {
        
        if !useInputVarsForInit {
            try await setInitVars(in: vars)
        }
        try await runInitActions(with: vars, and: scope)
//        await vars.removeReturnVariable()
        try await updateVariablesFromContent(vars: vars, and: scope)
//        await vars.removeReturnVariable()
    }
    
    func setInitVars(in vars: Variables) async throws {
        await vars.set(from: initVariables)
    }
    
    func runInitActions(with vars: Variables, and scope: Scope) async throws {
        for action in initActions {
            do {
                try await action.run(with: vars, and: scope)
            } catch {
                print(error)
            }
        }
    }
    
    func updateVariablesFromContent(vars: Variables, and scope: Scope) async throws {
        for element in content.content.value.constant?.elements ?? [] {
            guard let element = element as? (any MakeableView) else { return }
            try? await element.insertValues(into: vars, with: scope)
        }
    }
}
