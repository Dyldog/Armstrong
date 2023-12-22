//
//  ValueStep.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI

public protocol ValueStep: StepType {
    func run(with variables: Variables, and scope: Scope) throws -> VariableValue
}
