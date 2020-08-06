//
//  File.swift
//  WAKEPARKBY
//
//  Created by Anjey Novicki on 7/13/20.
//  Copyright © 2020 Anjey Novicki. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

var user:Person = Person()
var isRegistered: Bool = false

struct Person: Codable {
    var phoneNumber: String = ""
    var name: String = ""
    var surname: String = ""
    var subscription: Int = -1
    var bday: Date = Date()
    var uid: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case surname
        case subscription
        case uid
        case phoneNumber
        case bday
    }
}

func format(with mask: String, phone: String) -> String {
    let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    var result = ""
    var index = numbers.startIndex

    for ch in mask where index < numbers.endIndex {
        if ch == "X" {
            result.append(numbers[index])
            index = numbers.index(after: index)
        } else {
            result.append(ch)
        }
    }
    return result
}
