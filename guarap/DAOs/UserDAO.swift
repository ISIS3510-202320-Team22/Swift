//
//  UserDAO.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 28-10-2023.
//

import Foundation
import SwiftUI
import FirebaseStorage

protocol UserDAO {
    
    static var shared: UserDAO { get }
    
    func storeUsernameFromUserId(userId: String, completion: @escaping (String) -> Void)
}
