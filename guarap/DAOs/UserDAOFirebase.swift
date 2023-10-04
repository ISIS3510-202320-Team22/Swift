//
//  UserDAOImpl.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI

class UserDAOFirebase: UserDAO {
    
    private init(){}
    
    static var shared: UserDAO = UserDAOFirebase()
    
    func createUser(email: String, username: String, image: Image?) async throws {
        
    }
    
    func getUserByEmail(email: String) async throws {
        
    }
    
    func getUserByUsername(username: String) async throws {
        
    }
}
