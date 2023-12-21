//
//  MakeableLAbel.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import SwiftUI
import DylKit

public struct MakeableLabelView: View {
    let isRunning: Bool
    let showEditControls: Bool
    let scope: Scope
    let label: MakeableLabel
    
    let onContentUpdate: (MakeableLabel) -> Void
    let onRuntimeUpdate: (@escaping Block) -> Void
    
    @EnvironmentObject var variables: Variables
    @Binding var error: VariableValueError?
    
    @State var text: String = "LOADING"
    @State var fontSize: Int = 18
    @State var fontWeight: Font.Weight = .regular
    @State var italic: Bool = false
    @State var base: MakeableBase = .makeDefault()
    @State var textColor: Color = .black
    @State var isMultiline: Bool = false
    
    
    public init(isRunning: Bool, showEditControls: Bool, scope: Scope, label: MakeableLabel, onContentUpdate: @escaping (MakeableLabel) -> Void, onRuntimeUpdate: @escaping (@escaping Block) -> Void, error: Binding<VariableValueError?>) {
        self.isRunning = isRunning
        self.showEditControls = showEditControls
        self.label = label
        self.onContentUpdate = onContentUpdate
        self.onRuntimeUpdate = onRuntimeUpdate
        self._error = error
        self.scope = scope
    }
    
    func labelText() async -> String {
        do {
            if isRunning {
                let value = try await label.text.value(with: variables, and: scope).valueString
                return value
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
    
    private func updateValues() async  {
        do {
            self.text = await labelText()
            self.fontSize = (try await label.fontSize.value(with: variables, and: scope) as IntValue).value
            self.fontWeight = (try await label.fontWeight.value(with: variables, and: scope) as FontWeightValue).value
            self.italic = (try await label.italic.value(with: variables, and: scope) as BoolValue).value
            self.base = (try await label.base.value(with: variables, and: scope) as MakeableBase)
            self.textColor = (try await label.textColor.value(with: variables, and: scope) as ColorValue).value
            self.isMultiline = (try await label.isMultiline.value(with: variables, and: scope) as BoolValue).value
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
                await updateValues()
            }
            .any
    }
}

public final class MakeableLabel: MakeableView {
    
    public static var type: VariableType { .label }
    
    public let id: UUID
        
    @Published public var text: AnyValue
    @Published public var fontSize: IntValue
    @Published public var fontWeight: FontWeightValue
    @Published public var italic: BoolValue
    @Published public var base: MakeableBase
    @Published public var textColor: ColorValue
    @Published public var isMultiline: BoolValue
    
    public init(id: UUID, text: AnyValue, fontSize: IntValue, fontWeight: FontWeightValue, italic: BoolValue, base: MakeableBase, textColor: ColorValue, isMultiline: BoolValue) {
        self.id = id
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
            id: .init(),
            text: AnyValue(value: StringValue(value: string)),
            fontSize: IntValue(value: fontSize),
            fontWeight: .init(value: bold ? .bold : .regular),
            italic: .init(value: false),
            base: .makeDefault(), 
            textColor: .init(value: .black),
            isMultiline: .init(value: multiline)
        )
    }
    
    public func insertValues(into variables: Variables, with scope: Scope) throws { }
    
    public var protoString: String { "LABEL(\(text.protoString))" }
    
    public func add(_ other: VariableValue) throws -> VariableValue { fatalError() }
    
    public var valueString: String { text.valueString }

    public func value(with variables: Variables, and scope: Scope) async throws -> VariableValue {
        await MakeableLabel(
            id: id,
            text: (try text.value(with: variables, and: scope) as (any EditableVariableValue)).any,
            fontSize: try fontSize.value(with: variables, and: scope),
            fontWeight: try fontWeight.value(with: variables, and: scope),
            italic: try italic.value(with: variables, and: scope),
            base: try base.value(with: variables, and: scope),
            textColor: try textColor.value(with: variables, and: scope),
            isMultiline: try isMultiline.value(with: variables, and: scope)
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
        .init(id: .init(), text: text, fontSize: .int(size), fontWeight: .init(value: .regular), italic: .init(value: false), base: .makeDefault(), textColor: .init(value: .black), isMultiline: .false)
    }
}
