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
}

public class AALibrary {
    public static var shared: AALibrary = .init()
    
    private(set) var providers: [AAProvider.Type] = []
    
    public var steps: [any StepType.Type] { providers.flatMap { $0.steps } }
    public var values: [any EditableVariableValue.Type] { providers.flatMap { $0.values } }
    public var views: [any MakeableView.Type] { providers.flatMap { $0.views } }
    
    public func addProviders(_ providers: [AAProvider.Type]) {
        self.providers.append(contentsOf: providers)
    }
}
