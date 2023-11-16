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
    static var imageDao: ImageDAO { get }
    static var userDao: UserDAO { get }
    
    func createPost(description: String, image: UIImage?, category: String, address: String, completion: @escaping (Bool) -> Void)
    func getPostsByCategory(categoryName: String) async throws -> [Post]
    func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void)
    func getPostsWithImages(posts: [Post], completion: @escaping ([PostWithImage]) -> Void)
    func sendBugReport(title: String, description: String, completion: @escaping (Bool) -> Void)
}
