//
//  GurapRepository.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI

protocol GuarapRepository {
    
    static var shared: GuarapRepository { get }
    
    static var postDao: PostDAO { get }
    static var userDao: UserDAO { get }
    static var imageDao: ImageDAO { get }
    
    func createUser(email: String, username: String, image: Image?) async throws
    func getUserByEmail(email: String) async throws
    func getUserByUsername(username: String) async throws
    func createPost(title: String, description: String, image: Image?, category: String) async throws
    func getPostsByCategory(categoryName: String) async throws -> [Post]
    func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void)
}
