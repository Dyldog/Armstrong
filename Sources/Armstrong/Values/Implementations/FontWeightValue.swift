//
//  FontWeightValue.swift
//  AppApp
//
//  Created by Dylan Elliott on 24/11/2023.
//

import SwiftUI
import Armstrong

extension Font.Weight: PickableValue {
    
    public static var defaultValue: Font.Weight { .regular }
    
    public static var allCases: [Font.Weight] { [
        .regular,
        .bold,
        .semibold,
        .black, .heavy, .light, .ultraLight, .thin,
    ] }
    
    public var title: String {
        switch self {
        case .black: return "Black"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .light: return "Light"
        case .ultraLight: return "Ultralight"
        case .semibold: return "Semibold"
        case .thin: return "Thin"
        case .regular: return "Regular"
        default: return "???"
        }
    }
}
    
extension Font.Weight: Codable {
    public init(from decoder: Decoder) throws {
        let title = try decoder.singleValueContainer().decode(String.self)
        guard let value = Self.allCases.first(where: { $0.title == title }) else {
            throw DecodingError.valueNotFound(Font.Weight.self, .init(codingPath: [], debugDescription: ""))
        }
        self = value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(title)
    }
}

extension Font.Weight: CodeRepresentable {
    public var codeRepresentation: String {
        switch self {
        case .black: return ".black"
        case .bold: return ".bold"
        case .heavy: return ".heavy"
        case .light: return ".light"
        case .ultraLight: return ".ultraLight"
        case .semibold: return ".semibold"
        case .thin: return ".thin"
        case .regular: return ".regular"
        default: return "???"
        }
    }
}
