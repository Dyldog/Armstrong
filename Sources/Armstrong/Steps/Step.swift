//
//  Step.swift
//  AppApp
//
//  Created by Dylan Elliott on 20/11/2023.
//

import Foundation
import SwiftUI

public protocol Step: StepType {
    func run(with variables: Variables) async throws
}
