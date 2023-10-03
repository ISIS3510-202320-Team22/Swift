//
//  UserDAO.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI

protocol UserDAO {
    func createUser(email: String, username: String, image: Image?)
    func getUserByEmail(email: String)
    func getUserByUsername(username: String)
}
