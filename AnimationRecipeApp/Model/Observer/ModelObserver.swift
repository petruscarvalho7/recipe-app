//
//  Model.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI
import Observation

enum LoggedInOut: String {
    case loggedIn
    case onboarding
}

@Observable
class ModelObserver {
    // Tab Bar
    var showTab: Bool = true
     
    // Navigation Bar
    var showNav: Bool = true
    
    // Modal
    var loggedInOut: LoggedInOut = .loggedIn
    var showModal: Bool = false
    var dismissModal: Bool = false
    
    // Detail View
    var showDetail: Bool = false
    var selectedCourse: Int = 0
}
