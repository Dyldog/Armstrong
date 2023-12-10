//
//  ViewContructor.swift
//  AppApp
//
//  Created by Dylan Elliott on 21/11/2023.
//

import Foundation

/// Produces a `ViewEditable` without arguments
public protocol ViewConstructor {
    var view: any ViewEditable { get }
}
