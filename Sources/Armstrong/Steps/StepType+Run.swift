//
//  StepType+Run.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

extension StepType {
    public func run(with variables: Variables) async throws {
        switch self {
        case let step as any ValueStep:
            try await variables.set(step.run(with: variables), for: "$0")
        case let step as any Step:
            try await step.run(with: variables)
        default:
            fatalError()
        }
    }
    
}
