//
//  File.swift
//  
//
//  Created by Dylan Elliott on 10/12/2023.
//

import Foundation

public protocol AAProvider {
    var steps: [any StepType] { get }
}
