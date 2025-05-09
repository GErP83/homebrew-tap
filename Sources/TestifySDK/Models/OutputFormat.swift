//
//  OutputFormat.swift
//  Testify
//
//  Created by Lengyel Gábor on 2023. 02. 17..
//

import Foundation

public enum OutputFormat: String, CaseIterable, Sendable {
    case json
    case junit
    case md
    case gfm
}
