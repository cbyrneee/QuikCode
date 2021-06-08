//
//  Scan.swift
//  QuikCode
//
//  Created by Conor on 08/06/2021.
//

import Foundation

struct Scan : Identifiable, Codable {
    let image: Data
    let date: Date
    let result: String
    var id: String { UUID().uuidString }
}
