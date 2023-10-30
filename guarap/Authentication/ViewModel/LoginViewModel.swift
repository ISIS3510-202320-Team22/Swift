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
    @Published var didFailSignIn = false
    
    func signIn() async {
        do {
            try await AuthService.shared.login(withEmail: email, password: password)
        } catch {
            didFailSignIn = true
        }
    }
}

