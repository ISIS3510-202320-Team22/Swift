//
//  AuthService.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase
import SwiftUI

class AuthService{
    @AppStorage("userUID") var userUID = ""
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        Task { try await loadUserData() }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            userUID = self.userSession!.uid
            print(userUID)
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
            await self.uploadUserData(uid: result.user.uid, username: username, email: email)
            print("DEBUG: Did upload user data...")
        } catch {
            print("DEBUG: Failed to register user with \(error.localizedDescription)")
            
        }
        
    }
    
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = self.userSession?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
        print("DEBUG: Snapshot data is \(snapshot.data())")
    }
    
    func signOut (){
        try? Auth.auth().signOut()
        self.userSession = nil
        userUID = ""
        print(userUID)
    }
    
    private func uploadUserData(uid: String, username: String, email: String) async {
        let user = User(id: uid, username: username, email: email)
        
        do {
            let encoder = JSONEncoder()
            let userData = try encoder.encode(user)
            if let json = try JSONSerialization.jsonObject(with: userData, options: []) as? [String: Any] {
                try await Firestore.firestore().collection("users").document(user.id).setData(json)
            }
        } catch {
            print("Error al codificar y subir datos a Firestore: \(error)")
        }
    }

}
