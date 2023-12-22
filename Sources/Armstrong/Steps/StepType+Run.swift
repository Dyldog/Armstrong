//
//  StepType+Run.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

extension StepType {
    public func run(with variables: Variables, and scope: Scope) throws {
        switch self {
        case let step as any ValueStep:
            try variables.set(step.run(with: variables, and: scope), for: "$0")
        case let step as any Step:
            try step.run(with: variables, and: scope)
        default:
            fatalError()
        }
    }
    
}
