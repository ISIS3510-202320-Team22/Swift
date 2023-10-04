//
//  PostDAO.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI

protocol PostDAO {
    
    static var shared: PostDAO { get }
    
    func createPost(title: String, description: String, image: Image?, category: String)
    func getPostsByCategory(categoryName: String) async throws -> [Post]
}
