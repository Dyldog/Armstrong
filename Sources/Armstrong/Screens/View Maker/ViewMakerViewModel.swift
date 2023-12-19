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
    @Published var title: String
    
    var content: MakeableStack {
        willSet {
            objectWillChange.send()
        }
        didSet {
            onUpdate?(screen)
        }
    }
    
    @Published private(set) var screen: Screen
    private let onUpdate: ((Screen) -> Void)?
    var showEdit: Bool { onUpdate != nil }
    
    @Published var showErrors: Bool = false
//    var error: VariableValueError?
    
    var makeMode: Bool = false {
        didSet {
            Task {
                do {
                    try await self.makeNewVariables()
                } catch {
                    if let error = error as? VariableValueError {
                        self.error = error
                    } else {
                        print("Unhandled error: \(error)")
                    }
                }
            }
        }
    }
    
    @Published private(set) var updater: Int = 0
    
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
        self.screen = screen
        self.title = screen.name
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
        
        $title.dropFirst().sink { [weak self] in
            guard let self else { return }
            self.screen.name = $0
            self.onUpdate?(self.screen)
            
        }
        .store(in: &cancellables)
        
//        $content.dropFirst().sink { content in
//            onUpdate(.init(name: self.name, initActions: self.initActions, content: content))
//        }.store(in: &cancellables)
        
//        $_variables.compactMap { $0 }.sink { vars in
//            var newVars = vars
//            self.updateVariablesFromContent(vars: &newVars)
//            self._variables = newVars
//        }.store(in: &cancellables)
    }
    
    func makeNewVariables() async throws {
        self._variables = try await self.makeVariables()
    }
    
    func makeVariables() async throws -> Variables {
        let newVars = Variables()
        try await screen.initialise(with: newVars)
        hasFinishedFirstLoad = true
        return newVars
    }
    
    func onRuntimeUpdate(completion: @escaping Block) {
        Task { @MainActor in
            try await screen.updateVariablesFromContent(vars: variables)
            completion()
//            self.updater += 1
        }
    }
    
    func updateInitActions(_ newValue: StepArray) {
        Task { @MainActor in
            screen.initActions = newValue
            try await makeNewVariables()
            onUpdate?(screen)
        }
    }
    
    func updateInitVariables(_ newValue: DictionaryValue) {
        Task { @MainActor in
            screen.initVariables = newValue
            try await makeNewVariables()
            onUpdate?(screen)
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
