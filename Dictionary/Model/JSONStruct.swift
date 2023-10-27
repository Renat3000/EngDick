//
//  JSONStruct.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.10.2023.
//

import Foundation

struct JSONStruct: Decodable {
    let word: String
    let meanings: [Meaning]
    let phonetic: String?
}

struct Meaning: Decodable {
    let partOfSpeech: String?
    let definitions: [Definition]
//    let synonyms: [String]
}

struct Definition: Decodable {
    let definition: String
    let example: String?
}
