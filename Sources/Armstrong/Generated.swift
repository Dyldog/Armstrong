// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

public enum NumericType: String, Codable, CaseIterable {
    public static var defaultValue: NumericType = .int
    public var title: String { rawValue.capitalized }

    case float
    case int
    public func make(from string: String) throws -> any VariableValue {
        switch self {
        case .float:
            guard let value = Float(string) else { throw VariableValueError.wrongTypeForOperation }
            return FloatValue(value: value)
        case .int:
            guard let value = Int(string) else { throw VariableValueError.wrongTypeForOperation }
            return IntValue(value: value)
        }
    }
}

extension NumericType: CodeRepresentable {
    public var codeRepresentation: String {
        title
    }
}



public class Armstrong: AAProvider {
    public static var steps: [any StepType.Type] {
    [
        SetVarStep.self
    ]
    }
    public static var values: [any EditableVariableValue.Type] {
    [
    AnyMakeableView.self,
    AnyValue.self,
    ArrayValue.self,
    BoolValue.self,
    ColorValue.self,
    DictionaryValue.self,
    MakeableBase.self,
    MakeableLabel.self,
    MakeableStack.self,
    NilValue.self,
    NumericalOperationTypeValue.self,
    NumericalOperationValue.self,
    ResultValue.self,
    SetVarStep.self,
    StepArray.self,
    StringValue.self,
    Variable.self,
    VariableTypeValue.self,
    FloatValue.self,
    IntValue.self,
    AxisValue.self,
    FontWeightValue.self,
    NumericTypeValue.self
    ]
    }
    public static var views: [any MakeableView.Type] {
    [
    MakeableBase.self,
    MakeableLabel.self,
    MakeableStack.self
    ]
    }
}

import SwiftUI



extension MakeableBase {
    public func make(isRunning: Bool, showEditControls: Bool, onContentUpdate: @escaping (any MakeableView) -> Void, onRuntimeUpdate: @escaping () -> Void, error: Binding<VariableValueError?>) -> AnyView {
        MakeableBaseView(isRunning: isRunning, showEditControls: showEditControls, base: self, onContentUpdate: onContentUpdate, onRuntimeUpdate: onRuntimeUpdate, error: error).any
    }
}
extension MakeableLabel {
    public func make(isRunning: Bool, showEditControls: Bool, onContentUpdate: @escaping (any MakeableView) -> Void, onRuntimeUpdate: @escaping () -> Void, error: Binding<VariableValueError?>) -> AnyView {
        MakeableLabelView(isRunning: isRunning, showEditControls: showEditControls, label: self, onContentUpdate: onContentUpdate, onRuntimeUpdate: onRuntimeUpdate, error: error).any
    }
}
extension MakeableStack {
    public func make(isRunning: Bool, showEditControls: Bool, onContentUpdate: @escaping (any MakeableView) -> Void, onRuntimeUpdate: @escaping () -> Void, error: Binding<VariableValueError?>) -> AnyView {
        MakeableStackView(isRunning: isRunning, showEditControls: showEditControls, stack: self, onContentUpdate: onContentUpdate, onRuntimeUpdate: onRuntimeUpdate, error: error).any
    }
}




public final class AxisValue: PrimitiveEditableVariableValue, Codable, Copying {

    public static var type: VariableType { .axis }
    public static var defaultValue: Axis { .defaultValue }
    public var value: Axis
    public init(value: Axis) {
        self.value = value
    }
    public static func makeDefault() -> AxisValue {
        .init(value: defaultValue)
    }
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(Self.type, "add")
    }
    public var protoString: String { "\(value.title)" }
    public var valueString: String { protoString }
    public func value(with variables: Variables) async throws -> VariableValue {
        self
    }
    public func copy() -> AxisValue {
        .init(
            value: value
        )
    }
}

extension AxisValue: CodeRepresentable {
    public var codeRepresentation: String {
        value.codeRepresentation
    }
}

extension Axis: Copying {
    public func copy() -> Axis {
        return self
    }
}

extension VariableType {
    public static var axis: VariableType { .init(title: "Axis") } // Axis
}

public final class FontWeightValue: PrimitiveEditableVariableValue, Codable, Copying {

    public static var type: VariableType { .fontWeight }
    public static var defaultValue: Font.Weight { .defaultValue }
    public var value: Font.Weight
    public init(value: Font.Weight) {
        self.value = value
    }
    public static func makeDefault() -> FontWeightValue {
        .init(value: defaultValue)
    }
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(Self.type, "add")
    }
    public var protoString: String { "\(value.title)" }
    public var valueString: String { protoString }
    public func value(with variables: Variables) async throws -> VariableValue {
        self
    }
    public func copy() -> FontWeightValue {
        .init(
            value: value
        )
    }
}

extension FontWeightValue: CodeRepresentable {
    public var codeRepresentation: String {
        value.codeRepresentation
    }
}

extension Font.Weight: Copying {
    public func copy() -> Font.Weight {
        return self
    }
}

extension VariableType {
    public static var fontWeight: VariableType { .init(title: "FontWeight") } // Font.Weight
}

public final class NumericTypeValue: PrimitiveEditableVariableValue, Codable, Copying {

    public static var type: VariableType { .numericType }
    public static var defaultValue: NumericType { .defaultValue }
    public var value: NumericType
    public init(value: NumericType) {
        self.value = value
    }
    public static func makeDefault() -> NumericTypeValue {
        .init(value: defaultValue)
    }
    public func add(_ other: VariableValue) throws -> VariableValue {
        throw VariableValueError.variableCannotPerformOperation(Self.type, "add")
    }
    public var protoString: String { "\(value.title)" }
    public var valueString: String { protoString }
    public func value(with variables: Variables) async throws -> VariableValue {
        self
    }
    public func copy() -> NumericTypeValue {
        .init(
            value: value
        )
    }
}

extension NumericTypeValue: CodeRepresentable {
    public var codeRepresentation: String {
        value.codeRepresentation
    }
}

extension NumericType: Copying {
    public func copy() -> NumericType {
        return self
    }
}

extension VariableType {
    public static var numericType: VariableType { .init(title: "NumericType") } // NumericType
}





public final class FloatValue: EditableVariableValue, Codable, Copying, NumericValue {
    public static var type: VariableType { .float }
    public var value: Float
    public static var defaultValue: Float = .defaultValue
    public init(value: Float) {
        self.value = value
    }
    public static func makeDefault() -> FloatValue {
        .init(value: Self.defaultValue)
    }
    public func editView(title: String, onUpdate: @escaping (FloatValue) -> Void) -> AnyView {
        TextField("", text: .init(get: { [weak self] in
            self?.protoString ?? "ERROR"
        }, set: { [weak self] in
            guard let self = self else { return }
            self.value = Float($0) ?? self.value
            onUpdate(self)
        })).any
    }
    public func add(_ other: VariableValue) throws -> VariableValue {
        guard let other = other as? FloatValue else { throw VariableValueError.wrongTypeForOperation }
        self.value = self.value + other.value
        return self
    }
    public var protoString: String { "\(value)" }
    public var valueString: String { "\(value)"}
    public func value(with variables: Variables) throws -> VariableValue {
        self
    }
    public func copy() -> FloatValue {
        .init(
            value: value
        )
    }
}

extension FloatValue: CodeRepresentable {
    public var codeRepresentation: String {
        "\(value)"
    }
}

extension Float: Copying {
    public func copy() -> Float {
        return Float(
        )
    }
}

extension VariableType {
    public static var float: VariableType { .init(title: "Float") } // Float
}

public final class IntValue: EditableVariableValue, Codable, Copying, NumericValue {
    public static var type: VariableType { .int }
    public var value: Int
    public static var defaultValue: Int = .defaultValue
    public init(value: Int) {
        self.value = value
    }
    public static func makeDefault() -> IntValue {
        .init(value: Self.defaultValue)
    }
    public func editView(title: String, onUpdate: @escaping (IntValue) -> Void) -> AnyView {
        TextField("", text: .init(get: { [weak self] in
            self?.protoString ?? "ERROR"
        }, set: { [weak self] in
            guard let self = self else { return }
            self.value = Int($0) ?? self.value
            onUpdate(self)
        })).any
    }
    public func add(_ other: VariableValue) throws -> VariableValue {
        guard let other = other as? IntValue else { throw VariableValueError.wrongTypeForOperation }
        self.value = self.value + other.value
        return self
    }
    public var protoString: String { "\(value)" }
    public var valueString: String { "\(value)"}
    public func value(with variables: Variables) throws -> VariableValue {
        self
    }
    public func copy() -> IntValue {
        .init(
            value: value
        )
    }
}

extension IntValue: CodeRepresentable {
    public var codeRepresentation: String {
        "\(value)"
    }
}

extension Int: Copying {
    public func copy() -> Int {
        return Int(
        )
    }
}

extension VariableType {
    public static var int: VariableType { .init(title: "Int") } // Int
}




// AnyMakeableView

extension AnyMakeableView: Copying {
    public func copy() -> AnyMakeableView {
        return AnyMakeableView(
                    value: value
        )
    }
}


extension VariableType {
    public static var view: VariableType { .init(title: "view") } // AnyMakeableView
}

// AnyValue

extension AnyValue: Copying {
    public func copy() -> AnyValue {
        return AnyValue(
                    value: value
        )
    }
}


extension VariableType {
    public static var anyValue: VariableType { .init(title: "anyValue") } // AnyValue
}

// ArrayValue

extension ArrayValue: Copying {
    public func copy() -> ArrayValue {
        return ArrayValue(
                    type: type,
                    elements: elements
        )
    }
}


extension VariableType {
    public static var list: VariableType { .init(title: "list") } // ArrayValue
}

// BoolValue

extension BoolValue: Copying {
    public func copy() -> BoolValue {
        return BoolValue(
                    value: value
        )
    }
}


extension VariableType {
    public static var boolean: VariableType { .init(title: "boolean") } // BoolValue
}

// ColorValue

extension ColorValue: Copying {
    public func copy() -> ColorValue {
        return ColorValue(
                    value: value
        )
    }
}


extension VariableType {
    public static var color: VariableType { .init(title: "Color") } // ColorValue
}

// DictionaryValue

extension DictionaryValue: Copying {
    public func copy() -> DictionaryValue {
        return DictionaryValue(
                    type: type.copy(),
                    elements: elements
        )
    }
}


extension VariableType {
    public static var dictionary: VariableType { .init(title: "Dictionary") } // DictionaryValue
}

// MakeableBase

extension MakeableBase: Copying {
    public func copy() -> MakeableBase {
        return MakeableBase(
                    padding: padding,
                    backgroundColor: backgroundColor.copy(),
                    cornerRadius: cornerRadius
        )
    }
}

extension MakeableBase {
     public enum Properties: String, ViewProperty {
        case padding
        case backgroundColor
        case cornerRadius
        public var defaultValue: any EditableVariableValue {
            switch self {
            case .padding: return MakeableBase.defaultValue(for: .padding)
            case .backgroundColor: return MakeableBase.defaultValue(for: .backgroundColor)
            case .cornerRadius: return MakeableBase.defaultValue(for: .cornerRadius)
            }
        }
    }
    public static func make(factory: (Properties) -> any EditableVariableValue) -> Self {
        .init(
            padding: factory(.padding) as! IntValue,
            backgroundColor: factory(.backgroundColor) as! ColorValue,
            cornerRadius: factory(.cornerRadius) as! IntValue
        )
    }

    public static func makeDefault() -> Self {
        .init(
            padding: Properties.padding.defaultValue as! IntValue,
            backgroundColor: Properties.backgroundColor.defaultValue as! ColorValue,
            cornerRadius: Properties.cornerRadius.defaultValue as! IntValue
        )
    }
    public func value(for property: Properties) -> any EditableVariableValue {
        switch property {
            case .padding: return padding
            case .backgroundColor: return backgroundColor
            case .cornerRadius: return cornerRadius
        }
    }

    public func set(_ value: Any, for property: Properties) {
        switch property {
            case .padding: self.padding = value as! IntValue
            case .backgroundColor: self.backgroundColor = value as! ColorValue
            case .cornerRadius: self.cornerRadius = value as! IntValue
        }
    }
}

extension VariableType {
    public static var base: VariableType { .init(title: "Base") } // MakeableBase
}

// MakeableLabel

extension MakeableLabel: Copying {
    public func copy() -> MakeableLabel {
        return MakeableLabel(
                    text: text.copy(),
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    italic: italic.copy(),
                    base: base.copy(),
                    textColor: textColor.copy(),
                    isMultiline: isMultiline.copy()
        )
    }
}

extension MakeableLabel {
     public enum Properties: String, ViewProperty {
        case text
        case fontSize
        case fontWeight
        case italic
        case base
        case textColor
        case isMultiline
        public var defaultValue: any EditableVariableValue {
            switch self {
            case .text: return MakeableLabel.defaultValue(for: .text)
            case .fontSize: return MakeableLabel.defaultValue(for: .fontSize)
            case .fontWeight: return MakeableLabel.defaultValue(for: .fontWeight)
            case .italic: return MakeableLabel.defaultValue(for: .italic)
            case .base: return MakeableLabel.defaultValue(for: .base)
            case .textColor: return MakeableLabel.defaultValue(for: .textColor)
            case .isMultiline: return MakeableLabel.defaultValue(for: .isMultiline)
            }
        }
    }
    public static func make(factory: (Properties) -> any EditableVariableValue) -> Self {
        .init(
            text: factory(.text) as! AnyValue,
            fontSize: factory(.fontSize) as! IntValue,
            fontWeight: factory(.fontWeight) as! FontWeightValue,
            italic: factory(.italic) as! BoolValue,
            base: factory(.base) as! MakeableBase,
            textColor: factory(.textColor) as! ColorValue,
            isMultiline: factory(.isMultiline) as! BoolValue
        )
    }

    public static func makeDefault() -> Self {
        .init(
            text: Properties.text.defaultValue as! AnyValue,
            fontSize: Properties.fontSize.defaultValue as! IntValue,
            fontWeight: Properties.fontWeight.defaultValue as! FontWeightValue,
            italic: Properties.italic.defaultValue as! BoolValue,
            base: Properties.base.defaultValue as! MakeableBase,
            textColor: Properties.textColor.defaultValue as! ColorValue,
            isMultiline: Properties.isMultiline.defaultValue as! BoolValue
        )
    }
    public func value(for property: Properties) -> any EditableVariableValue {
        switch property {
            case .text: return text
            case .fontSize: return fontSize
            case .fontWeight: return fontWeight
            case .italic: return italic
            case .base: return base
            case .textColor: return textColor
            case .isMultiline: return isMultiline
        }
    }

    public func set(_ value: Any, for property: Properties) {
        switch property {
            case .text: self.text = value as! AnyValue
            case .fontSize: self.fontSize = value as! IntValue
            case .fontWeight: self.fontWeight = value as! FontWeightValue
            case .italic: self.italic = value as! BoolValue
            case .base: self.base = value as! MakeableBase
            case .textColor: self.textColor = value as! ColorValue
            case .isMultiline: self.isMultiline = value as! BoolValue
        }
    }
}

extension VariableType {
    public static var label: VariableType { .init(title: "Label") } // MakeableLabel
}

// MakeableStack

extension MakeableStack: Copying {
    public func copy() -> MakeableStack {
        return MakeableStack(
                    base: base.copy(),
                    axis: axis,
                    content: content.copy()
        )
    }
}

extension MakeableStack {
     public enum Properties: String, ViewProperty {
        case base
        case axis
        case content
        public var defaultValue: any EditableVariableValue {
            switch self {
            case .base: return MakeableStack.defaultValue(for: .base)
            case .axis: return MakeableStack.defaultValue(for: .axis)
            case .content: return MakeableStack.defaultValue(for: .content)
            }
        }
    }
    public static func make(factory: (Properties) -> any EditableVariableValue) -> Self {
        .init(
            base: factory(.base) as! MakeableBase,
            axis: factory(.axis) as! AxisValue,
            content: factory(.content) as! TypedValue<ArrayValue>
        )
    }

    public static func makeDefault() -> Self {
        .init(
            base: Properties.base.defaultValue as! MakeableBase,
            axis: Properties.axis.defaultValue as! AxisValue,
            content: Properties.content.defaultValue as! TypedValue<ArrayValue>
        )
    }
    public func value(for property: Properties) -> any EditableVariableValue {
        switch property {
            case .base: return base
            case .axis: return axis
            case .content: return content
        }
    }

    public func set(_ value: Any, for property: Properties) {
        switch property {
            case .base: self.base = value as! MakeableBase
            case .axis: self.axis = value as! AxisValue
            case .content: self.content = value as! TypedValue<ArrayValue>
        }
    }
}

extension VariableType {
    public static var stack: VariableType { .init(title: "Stack") } // MakeableStack
}

// NilValue

extension NilValue: Copying {
    public func copy() -> NilValue {
        return NilValue(
        )
    }
}


extension VariableType {
    public static var `nil`: VariableType { .init(title: "`nil`") } // NilValue
}

// NumericalOperationTypeValue

extension NumericalOperationTypeValue: Copying {
    public func copy() -> NumericalOperationTypeValue {
        return NumericalOperationTypeValue(
                    value: value
        )
    }
}


extension VariableType {
    public static var numericalOperationType: VariableType { .init(title: "NumericalOperationType") } // NumericalOperationTypeValue
}

// NumericalOperationValue

extension NumericalOperationValue: Copying {
    public func copy() -> NumericalOperationValue {
        return NumericalOperationValue(
                    lhs: lhs.copy(),
                    rhs: rhs.copy(),
                    operation: operation.copy()
        )
    }
}

extension NumericalOperationValue {
     public enum Properties: String, ViewProperty {
        case lhs
        case rhs
        case operation
        public var defaultValue: any EditableVariableValue {
            switch self {
            case .lhs: return NumericalOperationValue.defaultValue(for: .lhs)
            case .rhs: return NumericalOperationValue.defaultValue(for: .rhs)
            case .operation: return NumericalOperationValue.defaultValue(for: .operation)
            }
        }
    }
    public static func make(factory: (Properties) -> any EditableVariableValue) -> Self {
        .init(
            lhs: factory(.lhs) as! AnyValue,
            rhs: factory(.rhs) as! AnyValue,
            operation: factory(.operation) as! NumericalOperationTypeValue
        )
    }

    public static func makeDefault() -> Self {
        .init(
            lhs: Properties.lhs.defaultValue as! AnyValue,
            rhs: Properties.rhs.defaultValue as! AnyValue,
            operation: Properties.operation.defaultValue as! NumericalOperationTypeValue
        )
    }
    public func value(for property: Properties) -> any EditableVariableValue {
        switch property {
            case .lhs: return lhs
            case .rhs: return rhs
            case .operation: return operation
        }
    }

    public func set(_ value: Any, for property: Properties) {
        switch property {
            case .lhs: self.lhs = value as! AnyValue
            case .rhs: self.rhs = value as! AnyValue
            case .operation: self.operation = value as! NumericalOperationTypeValue
        }
    }
}

extension VariableType {
    public static var numericalOperation: VariableType { .init(title: "NumericalOperation") } // NumericalOperationValue
}

// ResultValue

extension ResultValue: Copying {
    public func copy() -> ResultValue {
        return ResultValue(
                    steps: steps.copy()
        )
    }
}


extension VariableType {
    public static var result: VariableType { .init(title: "Result") } // ResultValue
}

// SetVarStep

extension SetVarStep: Copying {
    public func copy() -> SetVarStep {
        return SetVarStep(
                    varName: varName.copy(),
                    value: value.copy()
        )
    }
}

extension SetVarStep {
     public enum Properties: String, ViewProperty {
        case varName
        case value
        public var defaultValue: any EditableVariableValue {
            switch self {
            case .varName: return SetVarStep.defaultValue(for: .varName)
            case .value: return SetVarStep.defaultValue(for: .value)
            }
        }
    }
    public static func make(factory: (Properties) -> any EditableVariableValue) -> Self {
        .init(
            varName: factory(.varName) as! AnyValue,
            value: factory(.value) as! AnyValue
        )
    }

    public static func makeDefault() -> Self {
        .init(
            varName: Properties.varName.defaultValue as! AnyValue,
            value: Properties.value.defaultValue as! AnyValue
        )
    }
    public func value(for property: Properties) -> any EditableVariableValue {
        switch property {
            case .varName: return varName
            case .value: return value
        }
    }

    public func set(_ value: Any, for property: Properties) {
        switch property {
            case .varName: self.varName = value as! AnyValue
            case .value: self.value = value as! AnyValue
        }
    }
}

extension VariableType {
    public static var setVarStep: VariableType { .init(title: "SetVarStep") } // SetVarStep
}

// StepArray

extension StepArray: Copying {
    public func copy() -> StepArray {
        return StepArray(
                    value: value
        )
    }
}


extension VariableType {
    public static var stepArray: VariableType { .init(title: "StepArray") } // StepArray
}

// StringValue

extension StringValue: Copying {
    public func copy() -> StringValue {
        return StringValue(
                    value: value
        )
    }
}


extension VariableType {
    public static var string: VariableType { .init(title: "String") } // StringValue
}

// TypeableValue




// TypedValue

extension TypedValue: Copying {
    public func copy() -> TypedValue {
        return TypedValue(
                    value: value
        )
    }
}



// Variable

extension Variable: Copying {
    public func copy() -> Variable {
        return Variable(
                    value: value
        )
    }
}


extension VariableType {
    public static var variable: VariableType { .init(title: "Variable") } // Variable
}

// VariableTypeValue

extension VariableTypeValue: Copying {
    public func copy() -> VariableTypeValue {
        return VariableTypeValue(
                    value: value
        )
    }
}


extension VariableType {
    public static var type: VariableType { .init(title: "type") } // VariableTypeValue
}












