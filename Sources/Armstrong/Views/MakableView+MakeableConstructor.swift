//
//  MakableView+MakeableConstructor.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import Foundation

extension MakeableView {
    /// A constructor that allows the building of a `MakeableView`
    var makeableConstructor: MakeableViewConstructor {
        Self.makeableConstructor(self)
    }
    
    static var makeableConstructor: MakeableViewConstructor {
        Self.makeableConstructor(nil)
    }
    
    private static func makeableConstructor(_ instance: Self?) -> MakeableViewConstructor {
        .init(
            properties: Properties.allCases.reduce(into: [:], {
                $0[$1.rawValue] = instance?.value(for: $1) ?? $1.defaultValue
            })) { props in
                Self.make {
                    props[$0.rawValue] ?? $0.defaultValue
                }
            }
    }
}
