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

class AuthService{
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    static let shared = AuthService()
    
    init() {
        Task { try await loadUserData() }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserData()
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
    
    @MainActor
    func loadUserData() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = userSession?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
        func loadUserData() async throws {
            self.userSession = Auth.auth().currentUser
            guard let currentUid = self.userSession?.uid else { return }
            let snapshot = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
            
            if let userData = snapshot.data() {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(User.self, from: jsonData)
                    self.currentUser = userData
                } catch {
                    print("Error al decodificar los datos: \(error)")
                }
            } else {
                print("Los datos no son del tipo esperado")
            }
        }

        
    }
    
    func signOut (){
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
    
    private func uploadUserData(uid: String, username: String, email: String) async {
        let user = User(id: uid, username: username, email: email)
        self.currentUser = user
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
