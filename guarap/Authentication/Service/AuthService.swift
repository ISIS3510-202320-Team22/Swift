//
//  AuthService.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import Foundation
import FirebaseAuth

class AuthService{
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            
        } catch {
            print("DEBUG: Failed to log in with \(error.localizedDescription)")
            
        }
        
    }
    @MainActor
    func createUser(email: String, password: String, username: String) async throws {
        print("Email is \(email)")
        print("Password is \(password)")
        print("Username is \(username)")
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
        } catch {
            print("DEBUG: Failed to register user with \(error.localizedDescription)")
            
        }
        
    }
    
    func loadUserData() async throws {
        
    }
    
    func signOut (){
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}
