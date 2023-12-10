//
//  AxisValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 27/11/2023.
//

import SwiftUI

extension Axis: Codable, PickableValue {
    public static var defaultValue: Axis = .vertical
    public var title: String { description }
    
    public var codeRepresentation: String {
        switch self {
        case .horizontal: return ".horizontal"
        case .vertical: return ".vertical"
        }
    }
}

extension Axis {
    public init(from decoder: Decoder) throws {
        let title = try decoder.singleValueContainer().decode(String.self)
        guard let value = Self.allCases.first(where: { $0.title == title }) else {
            throw DecodingError.valueNotFound(Self.self, .init(codingPath: [], debugDescription: ""))
        }
        self = value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(title)
    }
}
