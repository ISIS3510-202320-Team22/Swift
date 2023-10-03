//
//  PostDAO.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI

protocol PostDAO {
    func createPost(title: String, description: String, image: Image?, category: String)
    func getPostsByCategory(categoryName: String)
}
