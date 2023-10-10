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
    
    func login(withEmail email: String, password: String) async throws {
        
    }
    
    func ccreateUser(email: String, password: String, username: String) async throws {
        
    }
    
    func loadUserData() async throws {
        
    }
    
    func singOut (){
        
    }
}