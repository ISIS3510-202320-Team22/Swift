//
//  LoginViewModel.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 11/10/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
