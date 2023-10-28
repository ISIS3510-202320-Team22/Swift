//
//  LoginViewModel.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 11/10/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = "e.gonzalez5@uniandes.edu.co"
    @Published var password = "esteban"
    
    func signIn() async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
