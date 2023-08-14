//
//  UserObserver.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 14/08/23.
//

import SwiftUI
import Observation

@Observable
class UserObserver {
    var loggedUser: User = User(fullname: "Monkey D. Luffy", email: "", profileImage: "defaultProfile")
    private(set) var validationMessage: String?
    
    func login(email: String) -> Void {
        if email.isEmail() {
            loggedUser.email = email
        }
    }
}
