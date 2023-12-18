//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import Foundation

public protocol AAProvider {
    static var steps: [any StepType.Type] { get }
    static var values: [any EditableVariableValue.Type] { get }
    static var views: [any MakeableView.Type] { get }
    static var demoScreens: [Screen] { get }
}

public class AALibrary {
    public static var shared: AALibrary = .init()
    
    private(set) var providers: [AAProvider.Type] = []
    
    public var steps: [any StepType.Type] {
        providers.flatMap { $0.steps }.sorted(by: { $0.title < $1.title })
    }
    public var values: [any EditableVariableValue.Type] {
        providers.flatMap { $0.values }.sorted(by: { $0.type.title < $1.type.title })
    }
    public var views: [any MakeableView.Type] {
        providers.flatMap { $0.views }.sorted(by: { $0.type.title < $1.type.title })
    }
    public var demoScreens: [Screen] {
        providers.flatMap { $0.demoScreens }.sorted(by: { $0.name < $1.name })
    }
    public var userScreens: [Screen] {
        Screen.screens
    }
    public var allScreens: [Screen] {
        userScreens + demoScreens
    }
    
    public func addProviders(_ providers: [AAProvider.Type]) {
        self.providers.append(contentsOf: providers)
    }
}
