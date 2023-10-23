//
//  ErrorDictionary.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 23.10.2023.
//

import Foundation

struct ErrorDictionary: Decodable {
    let title: String
    let message: String
    let resolution: String
}
