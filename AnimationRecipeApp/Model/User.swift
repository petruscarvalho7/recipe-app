//
//  User.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 12/08/23.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    var id: UUID?
    var fullname: String
    var email: String
    var profileImage: String
}

extension User {
    static let MOCK_USER = User(id: UUID(), fullname: "Monkey D. Luffy", email: "kingofthepirates@strawhat.com", profileImage: "defaultProfile")
}
