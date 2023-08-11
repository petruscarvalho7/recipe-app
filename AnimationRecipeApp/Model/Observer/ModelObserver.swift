//
//  Model.swift
//  AnimationRecipeApp
//
//  Created by Petrus Carvalho on 05/08/23.
//

import SwiftUI
import Combine

enum LoggedInOut: String {
    case loggedIn
    case onboarding
}

class ModelObserver: ObservableObject {
    // Tab Bar
    @Published var showTab: Bool = true
     
    // Navigation Bar
    @Published var showNav: Bool = true
    
    // Modal
    @Published var loggedInOut: LoggedInOut = .loggedIn
    @Published var showModal: Bool = false
    @Published var dismissModal: Bool = false
    
    // Detail View
    @Published var showDetail: Bool = false
    @Published var selectedCourse: Int = 0
}
