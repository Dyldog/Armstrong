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
    
    private(set) var scope: Scope!
    
    @Published var showErrors: Bool = false
    var makeMode: Bool = false {
        didSet {
            do {
                _variables = try self.makeVariables()
            } catch {
                if let error = error as? VariableValueError {
//                    self.error = error
                } else {
                    print("Unhandled error: \(error)")
                }
            }
        }
    }
    @Published private(set) var displayedError: Error?
    @Published var _variables: Variables
    var variables: Variables? {
        get { makeMode ? nil : _variables }
        set {
            if let newValue { _variables = newValue }
        }
    }
    
    var error: VariableValueError? {
        willSet { if showErrors { objectWillChange.send() } }
        didSet {
            if showErrors {
                displayedError = error
            }
            
            print("ERROR: \(error?.localizedDescription ?? "NONE")")
            print("""
            VARIABLES:
            \(_variables.variables.map { "\t\($0.key): \($0.value.valueString)" }.joined(separator: "\n"))
            """)
        }
    }
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init(scope: Scope?, screen: Screen, makeMode: Bool, onUpdate: ((Screen) -> Void)?) {
        self.screen = screen
        self.title = screen.name
        self.content = screen.content
        self.onUpdate = onUpdate
        self._variables = .init()
        self.makeMode = makeMode
        
        self.scope = scope ?? .init()
        
        self.scope = self.scope.withScreens(screens: screen.subscreens.map { $0.name }) { screen in
            self.screen.subscreens.first(where: { $0.name == screen })
        }
        
                
        do {
            _variables = try self.makeVariables()
        } catch {
            if let error = error as? VariableValueError {
                self.error = error
            } else {
                print("Unhandled error: \(error)")
            }            
        }
        
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
    
    func makeVariables() throws -> Variables {
        var newVars = Variables()
        try screen.initialise(with: .init(get: {
            newVars
        }, set: {
            newVars = $0
        }), and: scope)
        
        return newVars
    }
    
    func onRuntimeUpdate(completion: @escaping Block) {
            do {
                try screen.updateVariablesFromContent(vars: .init(get: { [unowned self] in
                    _variables
                }, set: { [unowned self] in
                    _variables = $0
                }), and: scope)
                completion()
            } catch {
                handleError(error)
            }
        }
    
    func updateInitActions(_ newValue: StepArray) {
        do {
            screen.initActions = newValue
            _variables = try makeVariables()
            onUpdate?(screen)
        } catch {
            handleError(error)
        }
    }
    
    func updateInitVariables(_ newValue: DictionaryValue) {
        do {
            screen.initVariables = newValue
            _variables = try makeVariables()
            onUpdate?(screen)
        } catch {
            handleError(error)
        }
    }
    
    func updateSubscreens(_ newValue: [Screen]) {
        do {
            screen.subscreens = newValue
            _variables = try makeVariables()
            onUpdate?(screen)
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        if let error = error as? VariableValueError {
            self.error = error
        } else {
            print(error.localizedDescription)
        }
    }
}
