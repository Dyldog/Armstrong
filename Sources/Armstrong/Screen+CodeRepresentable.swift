//
//  Screen+CodaRepresentable.swift
//  AppApp
//
//  Created by Dylan Elliott on 3/12/2023.
//

import Foundation

extension Screen: CodeRepresentable {
    private var codeStructName: String { name.replacingOccurrences(of: " ", with: "") + "View" }
    
    public var codeRepresentation: String {
        return """
        struct \(codeStructName): View {
            \(initActions.setVariableSteps.map { $0.declarationCodeRepresentation }.joined(separator: "\n"))
        
            init() {
            \(initActions.declarationCodeRepresentation)
            }
            var body: some View {
        \(content.codeRepresentation.indented(2))
            }
        }
        """
    }
}

private extension StepArray {
    var setVariableSteps: [SetVarStep] { value.compactMap { $0 as? SetVarStep } }
}

private extension SetVarStep {
    var declarationCodeRepresentation: String {
        "@State var \(varName.valueString): \(Swift.type(of: value.value).type.codeRepresentation)"
    }
}
