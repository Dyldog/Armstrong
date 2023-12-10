//
//  CodableTypeString.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import Foundation

func typeString(_ value: VariableValue.Type) -> String {
    String(describing: value).replacingOccurrences(of: "AppApp.", with: "")
}

func typeString(_ value: any StepType.Type) -> String {
    String(describing: value).replacingOccurrences(of: "AppApp.", with: "")
}
