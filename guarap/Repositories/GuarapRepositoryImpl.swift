//
//  GuarapRepositoryImpl.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI

class GuarapRepositoryImpl: GuarapRepository {
    
    static var shared: GuarapRepository = GuarapRepositoryImpl()
    
    static let postDao: PostDAO = PostDAOFirebase.shared
    static let userDao: UserDAO = UserDAOFirebase.shared
    static let imageDao: ImageDAO = ImageDAOFirebase.shared
    
    func createUser(email: String, username: String, image: Image?) async throws {
        
    }
    
    func getUserByEmail(email: String) async throws {
        
    }
    
    func getUserByUsername(username: String) async throws {
        
    }
    
    func createPost(title: String, description: String, image: Image?, category: String) {
        
    }
    
    func getPostsByCategory(categoryName: String) async throws -> [Post] {
        return try await GuarapRepositoryImpl.postDao.getPostsByCategory(categoryName: categoryName)
    }
    
    func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void) {
        GuarapRepositoryImpl.imageDao.getImageFromUrl(url: url, completion: completion)
    }
}
