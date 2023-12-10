//
//  CodableStepList.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import Foundation

struct CodableStepList: Codable {
    let steps: [CodableStep]
    var values: [any StepType] { steps.map { $0.value } }
    
    init(steps: [CodableStep]) {
        self.steps = steps
    }
    
    init(steps: [any StepType]) {
        self.steps = steps.map { .init(value: $0) }
    }
}
