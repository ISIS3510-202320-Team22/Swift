//
//  UserDAOFirebase.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 28-10-2023.
//

import Foundation
import SwiftUI
import Firebase

class UserDAOFirebase: UserDAO {
    @AppStorage("userUID") var userUID = ""
    @AppStorage("username") var username = ""
    
    private init(){}

    static var shared: UserDAO = UserDAOFirebase()
    
    func storeUsernameFromUserId(userId: String, completion: @escaping (String) -> Void) {
        
        let firestore = Firestore.firestore()
        let user = firestore.collection("users").document(userId)
        
        user.getDocument { (document, error) in
            if let document = document, document.exists {
                let userDict = document.data()!
                
                if let name = userDict["username"] as? String {
                    UserDefaults.standard.set(name, forKey: "username")
                    completion(name)
                }
                
            } else {
                // Handle the case where the document doesn't exist or an error occurred
                print("Document does not exist or an error occurred: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
