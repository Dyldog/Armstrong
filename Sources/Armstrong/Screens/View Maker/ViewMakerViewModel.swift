//
//  ViewMakerViewModel.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit
import Combine

@MainActor
public class ViewMakerViewModel: ObservableObject {
    let name: String
    
    var content: MakeableStack {
        willSet {
            objectWillChange.send()
        }
        didSet {
            onUpdate?(.init(id: screenID, name: self.name, initActions: self.initActions, content: content))
        }
    }
    
    let screenID: UUID
    @Published private(set) var initActions: StepArray = .init(value: [])
    private let onUpdate: ((Screen) -> Void)?
    var showEdit: Bool { onUpdate != nil }
    
    @Published var showErrors: Bool = false
//    var error: VariableValueError?
    
    @Published var makeMode: Bool = false
    
//    @Published private(set) var updater: Int = 0
    
    @Published private(set) var _variables: Variables
    @Published var error: VariableValueError?
    @Published var hasFinishedFirstLoad: Bool = false
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    var variables: Variables {
        get {
            guard !makeMode else { return .init() }
            return _variables
        }
        set {
            guard !self.makeMode, newValue != self._variables else { return }
            self._variables.set(from: newValue)
        }
    }
    
    public init(screen: Screen, makeMode: Bool, onUpdate: ((Screen) -> Void)?) {
        self.screenID = screen.id
        self.name = screen.name
        self.initActions = screen.initActions
        self.content = screen.content
        self.onUpdate = onUpdate
        self._variables = .init()
        self.makeMode = makeMode
        
        print(screen.codeRepresentation)
        
        Task { @MainActor in
            do {
                try await self.makeNewVariables()
            } catch {
                if let error = error as? VariableValueError {
                    self.error = error
                } else {
                    print("Unhandled error: \(error)")
                }
                
                self.hasFinishedFirstLoad = true
            }
        }
        
        _variables.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        $makeMode.dropFirst().sink { [weak self] _ in
            Task {
                do {
                    try await self?.makeNewVariables()
                } catch {
                    if let error = error as? VariableValueError {
                        self?.error = error
                    } else {
                        print("Unhandled error: \(error)")
                    }
                }
            }
        }.store(in: &cancellables)
        
//        $content.dropFirst().sink { content in
//            onUpdate(.init(name: self.name, initActions: self.initActions, content: content))
//        }.store(in: &cancellables)
        
//        $_variables.compactMap { $0 }.sink { vars in
//            var newVars = vars
//            self.updateVariablesFromContent(vars: &newVars)
//            self._variables = newVars
//        }.store(in: &cancellables)
    }
    
    private func updateVariablesFromContent(vars: Variables) async throws {
        for element in (try await content.content.value(with: vars) as ArrayValue).elements {
            guard let element = element as? (any MakeableView) else { return }
            try? await element.insertValues(into: vars)
        }
        
        self.variables = vars
        
//        self.updater += 1
    }
    
    func makeNewVariables() async throws {
        self._variables = try await self.makeVariables()
    }
    
    func makeVariables() async throws -> Variables {
        let newVars = Variables()
        
        for action in initActions {
            do {
                try await action.run(with: newVars)
            } catch {
                print(error)
            }
        }
        
        variables.removeReturnVariable()
        
        try await self.updateVariablesFromContent(vars: newVars)
        
        variables.removeReturnVariable()
        
        hasFinishedFirstLoad = true
        
        return newVars
    }
    
    func onRuntimeUpdate() {
        Task { @MainActor in
            try await self.updateVariablesFromContent(vars: variables)
        }
    }
    
    func updateInitActions(_ newValue: StepArray) {
        Task { @MainActor in
            self.initActions = newValue
            try await makeNewVariables()
            onUpdate?(.init(id: screenID, name: self.name, initActions: self.initActions, content: self.content))
        }
    }
}

extension ViewMakerViewModel {
    struct EditRow: Identifiable {
        var id: Int { index }
        let index: Int
        let constructor: MakeableViewConstructor
    }
}
