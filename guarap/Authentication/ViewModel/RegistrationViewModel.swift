//
//  RegistrationViewModel.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isNextButtonTapped = false
    @Published var isNextButtonTapped1 = false
    @Published var isNextButtonTapped2 = false
    
    func createUser() async throws{
        try await AuthService.shared.createUser(email: email, password: password, userName: username)
        
        username = ""
        email = ""
        password = ""
    }

    func emailExists(email: String) async -> Bool {
        return await AuthService.shared.emailExists(email: email)
    }

}
