//
//  UserModel.swift
//  Flashcards
//
//  Created by Dylan Jackson on 4/19/23.
//

import Foundation
struct UserModel : Codable {
    let userId: Int64
    let name: String
    let pass: String
}
