//
//  UserModel.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import Foundation
struct UserModel : Codable {
    var userId: Int64
    var name: String
    var pass: String
}
