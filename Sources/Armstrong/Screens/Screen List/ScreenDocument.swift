//
//  ScreenDocument.swift
//  AppApp
//
//  Created by Dylan Elliott on 18/12/2023.
//

import SwiftUI
import UniformTypeIdentifiers
import Armstrong

extension UTType {
    static var screen: UTType { UTType(exportedAs: "com.dylan.AppAppScreen") }
    static var marqueeScreen: UTType { UTType(exportedAs: "com.dylan.AppAppMarqueeScreen") }
}

struct ScreenDocument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.screen, .marqueeScreen] }

    var screen: Screen

    init(screen: Screen) {
        self.screen = screen
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        screen = try JSONDecoder().decode(Screen.self, from: data)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: try JSONEncoder().encode(screen))
    }
    
}
