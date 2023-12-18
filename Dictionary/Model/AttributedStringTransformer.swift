//
//  AttributedStringTransformer.swift
//  Dictionary
//
//  Created by Renat Nazyrov on 18.12.2023.
//

import Foundation
import CoreData

@objc(AttributedStringTransformer)
class AttributedStringTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSAttributedString.self]
    }
}
