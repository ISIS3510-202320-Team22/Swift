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
    
    func createPost(description: String, image: UIImage?, category: String, latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void)
    func getPostsByCategory(categoryName: String) async throws -> [Post]
    func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void)
}
