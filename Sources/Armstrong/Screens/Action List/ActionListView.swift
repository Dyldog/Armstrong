//
//  ActionListView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

struct ActionListView: View {
    let scope: Scope
    let title: String
    @State var showAddIndex: Int?
    @State var steps: [any StepType]
    let onUpdate: ([any StepType]) -> Void
    let padSteps: Bool
    
    init(
        scope: Scope,
        title: String,
        padSteps: Bool = true,
        steps: [any StepType],
        onUpdate: @escaping ([any StepType]) -> Void
    ) {
        self.scope = scope
        self.title = title
        self.padSteps = padSteps
        self.steps = steps
        self.onUpdate = onUpdate
    }
    
    var body: some View {
        VStack {
            addButton(index: 0)
            
            ForEach(enumerated: steps) { (index, element) in
                VStack(spacing: 0) {
                    HStack {
                        Text(type(of: element).title)
                            .bold()
                            .scope(scope.next)
                            .onLongPressGesture {
                                DylKit.Pasteboard.general.copy(element)
                            }
                            .padding(.bottom)
                        
                        ElementDeleteButton(color: scope.next.color) {
                            steps = steps.removing(at: index)
                            onUpdate(steps)
                        }
                    }
                    
                    element.editView(scope: scope.next.next, title: title) { value in
                        onUpdate(steps.replacing(value, at: index))
                    }
                    .buttonStyle(.plain)
                }
                .if(padSteps) { $0.padding() }
                .background(RoundedRectangle(cornerRadius: 12).foregroundStyle(.white))
                .frame(maxWidth: .infinity)
                
                addButton(index: index + 1)
            }
        }
        .frame(maxWidth: .infinity).sheet(item: $showAddIndex) { index in
            AddActionView { newStep in
                steps = steps.inserting(newStep, at: index)
                onUpdate(steps)
                showAddIndex = nil
            }
        }
    }
    
    func addButton(index: Int) -> some View {
        LongPressButton {
            showAddIndex = index
        } longPressAction: {
            guard let step = DylKit.Pasteboard.general.pasteValue() as? any StepType else { return }
            steps = steps.inserting(step, at: index)
            onUpdate(steps)
        } label: {
            Image(systemName: "plus.app.fill")
        }
        .padding(4)
        .scope(scope)
    }
}

import AudioToolbox

public extension DylKit.Pasteboard {
    func copy(_ value: any EditableVariableValue) {
        self.string = CodableVariableValue(value: value).encoded().string
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }

    }
    
    func copy(_ screen: Screen) {
        self.string = screen.encoded().string
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }
    }
    
    func pasteValue() -> (any EditableVariableValue)? {
        guard let data = self.string?.data(using: .utf8), let value = try? JSONDecoder().decode(CodableVariableValue.self, from: data) else {
            return nil
        }
        
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }
        
        return value.value
    }
    
    func pasteScreen() -> Screen? {
        guard let data = self.string?.data(using: .utf8), let value = try? JSONDecoder().decode(Screen.self, from: data) else {
            return nil
        }
        
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }
        
        return value
    }
}
