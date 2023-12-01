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
    
    func createPost(description: String, imageUrl: String, category: String, address: String, completion: @escaping (Bool) -> Void)
    func createPostWithLikes(description: String, imageUrl: String, category: String, likes: Int, address: String, completion: @escaping (Bool) -> Void)
    func getPostsByCategory(categoryName: String) async throws -> [Post]
}
