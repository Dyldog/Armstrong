// Generated using Sourcery 2.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

extension AddViewViewModel {
    convenience init(onSelect: @escaping (any MakeableView) -> Void) {
        self.init(rows: [

            .init(title: "Stack", onTap: {
                onSelect(MakeableStack.makeDefault())
            })
        ])
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
    AnyValue.self,
    MakeableArray.self,
    MakeableStack.self,
    SetVarStep.self,
    StepArray.self,
    StringValue.self,
    AxisValue.self
    ]
    }
    public static var views: [any MakeableView.Type] {
    [
    MakeableStack.self
    ]
    }
}

import SwiftUI



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
    static var axis: VariableType { .init() } // Axis
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
    static var anyValue: VariableType { .init() } // AnyValue
}

// MakeableArray

extension MakeableArray: Copying {
    public func copy() -> MakeableArray {
        return MakeableArray(
                    value: value,
                    axis: axis
        )
    }
}


extension VariableType {
    static var makeableArray: VariableType { .init() } // MakeableArray
}

// MakeableStack

extension MakeableStack: Copying {
    public func copy() -> MakeableStack {
        return MakeableStack(
                    content: content.copy() as! MakeableArray
        )
    }
}

extension MakeableStack {
     public enum Properties: String, ViewProperty {
        case content
        public var defaultValue: any EditableVariableValue {
            switch self {
            case .content: return MakeableStack.defaultValue(for: .content)
            }
        }
    }
    public static func make(factory: (Properties) -> any EditableVariableValue) -> Self {
        .init(
            content: factory(.content) as! MakeableArray
        )
    }

    public static func makeDefault() -> Self {
        .init(
            content: Properties.content.defaultValue as! MakeableArray
        )
    }
    public func value(for property: Properties) -> any EditableVariableValue {
        switch property {
            case .content: return content
        }
    }

    public func set(_ value: Any, for property: Properties) {
        switch property {
            case .content: self.content = value as! MakeableArray
        }
    }
}

extension VariableType {
    static var stack: VariableType { .init() } // MakeableStack
}

// SetVarStep

extension SetVarStep: Copying {
    public func copy() -> SetVarStep {
        return SetVarStep(
                    varName: varName.copy() as! AnyValue,
                    value: value.copy() as! AnyValue
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
    static var setVarStep: VariableType { .init() } // SetVarStep
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
    static var stepArray: VariableType { .init() } // StepArray
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
    static var string: VariableType { .init() } // StringValue
}











