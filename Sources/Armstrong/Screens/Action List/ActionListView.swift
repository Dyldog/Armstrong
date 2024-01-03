//
//  ActionListView.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

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
                                SharedPasteboard.copy(element)
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
            guard let step = SharedPasteboard.pasteValue() as? any StepType else { return }
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

public extension Pasteboard {
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

public protocol Pasteboard: AnyObject {
    var string: String? { get set }
}

public var SharedPasteboard: Pasteboard {
#if canImport(UIKit)
    return UIPasteboard.general
#else
    return NSPasteboard.general
#endif
}

#if canImport(UIKit)
extension UIPasteboard: Pasteboard { }
#else
extension NSPasteboard: Pasteboard {
    public var string: String? {
        get {
            string(forType: .string)
        }
        set {
            guard let newValue else { return }
            setString(newValue, forType: .string)
        }
    }
}
#endif
