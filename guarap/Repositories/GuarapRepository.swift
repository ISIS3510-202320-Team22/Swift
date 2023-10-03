//
//  GurapRepository.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI

protocol GuarapRepository {
    func createUser(email: String, username: String, image: Image?)
    func getUserByEmail(email: String)
    func getUserByUsername(username: String)
    func createPost(title: String, description: String, image: Image?, category: String)
    func getPostsByCategory(categoryName: String)
}
