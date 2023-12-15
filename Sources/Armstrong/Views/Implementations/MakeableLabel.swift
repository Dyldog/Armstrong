//
//  MakeableLAbel.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import Armstrong

public struct MakeableLabelView: View {
    let isRunning: Bool
    let showEditControls: Bool
    let label: MakeableLabel
    
    let onContentUpdate: (MakeableLabel) -> Void
    let onRuntimeUpdate: () -> Void
    
    @EnvironmentObject var variables: Variables
    @Binding var error: VariableValueError?
    
    @State var text: String = "LOADING"
    @State var fontSize: Int = 18
    @State var fontWeight: Font.Weight = .regular
    @State var italic: Bool = false
    @State var base: MakeableBase = .makeDefault()
    @State var textColor: Color = .black
    @State var isMultiline: Bool = false
    
    
    public init(isRunning: Bool, showEditControls: Bool, label: MakeableLabel, onContentUpdate: @escaping (MakeableLabel) -> Void, onRuntimeUpdate: @escaping () -> Void, error: Binding<VariableValueError?>) {
        self.isRunning = isRunning
        self.showEditControls = showEditControls
        self.label = label
        self.onContentUpdate = onContentUpdate
        self.onRuntimeUpdate = onRuntimeUpdate
        self._variables = .init()
        self._error = error
    }
    
    func labelText() async -> String {
        do {
            if isRunning {
                return try await label.text.value(with: variables).valueString
            } else {
                return label.protoString
            }
        } catch let error as VariableValueError {
            self.error = error
            return "Error"
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public var body: some View {
        Text(text)
            .font(.system(size: CGFloat(fontSize)).weight(fontWeight))
            .if(italic) { $0.italic() }
            .lineLimit(isMultiline ? nil : 1)
            .foregroundStyle(textColor)
            .base(base)
            .task(id: variables.hashValue) {
                do {
                    self.text = await labelText()
                    self.fontSize = (try await label.fontSize.value(with: variables) as IntValue).value
                    self.fontWeight = (try await label.fontWeight.value(with: variables) as FontWeightValue).value
                    self.italic = (try await label.italic.value(with: variables) as BoolValue).value
                    self.base = (try await label.base.value(with: variables) as MakeableBase)
                    self.textColor = (try await label.textColor.value(with: variables) as ColorValue).value
                    self.isMultiline = (try await label.isMultiline.value(with: variables) as BoolValue).value
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
            .any
    }
}

public final class MakeableLabel: MakeableView {
    
    public static var type: VariableType { .label }
        
    public var text: AnyValue
    public var fontSize: IntValue
    public var fontWeight: FontWeightValue
    public var italic: BoolValue
    public var base: MakeableBase
    public var textColor: ColorValue
    public var isMultiline: BoolValue
    
    public init(text: AnyValue, fontSize: IntValue, fontWeight: FontWeightValue, italic: BoolValue, base: MakeableBase, textColor: ColorValue, isMultiline: BoolValue) {
        self.text = text
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.italic = italic
        self.base = base
        self.textColor = textColor
        self.isMultiline = isMultiline
    }
    
    public static func withText(
        _ string: String, fontSize: Int = 18, bold: Bool = false, multiline: Bool = false
    ) -> MakeableLabel {
        .init(
            text: AnyValue(value: StringValue(value: string)),
            fontSize: IntValue(value: fontSize),
            fontWeight: .init(value: bold ? .bold : .regular),
            italic: .init(value: false),
            base: .makeDefault(), 
            textColor: .init(value: .black),
            isMultiline: .init(value: multiline)
        )
    }
    
    public func insertValues(into variables: Variables) throws { }
    
    public var protoString: String { text.protoString }
    
    public func add(_ other: VariableValue) throws -> VariableValue { fatalError() }
    
    public var valueString: String { text.valueString }

    public func value(with variables: Variables) async throws -> VariableValue {
        await MakeableLabel(
            text: (try text.value(with: variables) as (any EditableVariableValue)).any,
            fontSize: try fontSize.value(with: variables),
            fontWeight: try fontWeight.value(with: variables),
            italic: try italic.value(with: variables),
            base: try base.value(with: variables),
            textColor: try textColor.value(with: variables),
            isMultiline: try isMultiline.value(with: variables)
        )
//        self
    }

    public static func defaultValue(for property: Properties) -> any EditableVariableValue {
        switch property {
        case .text: return AnyValue(value: StringValue(value: "TEXT"))
        case .fontSize: return IntValue(value: 18)
        case .fontWeight: return FontWeightValue(value: .regular)
        case .italic: return BoolValue(value: false)
        case .base: return MakeableBase.makeDefault()
        case .textColor: return ColorValue(value: .black)
        case .isMultiline: return BoolValue.false
        }
    }
}

extension MakeableLabel: CodeRepresentable {
    public var codeRepresentation: String {
        """
        Text("\\(\(text.codeRepresentation))\")
            .font(.system(size: \(fontSize.codeRepresentation)).weight(\(fontWeight.codeRepresentation)))
            .if(\(italic.codeRepresentation)) { $0.italic() }
            .foregroundStyle(\(textColor.codeRepresentation))
        """
    }
}

extension MakeableLabel {
    public static func text(_ text: AnyValue, size: Int = 18) -> MakeableLabel {
        .init(text: text, fontSize: .int(size), fontWeight: .init(value: .regular), italic: .init(value: false), base: .makeDefault(), textColor: .init(value: .black), isMultiline: .false)
    }
}
