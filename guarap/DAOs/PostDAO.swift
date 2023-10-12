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
    
    func createPost(description: String, imageUrl: String, category: String, latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void)
    func getPostsByCategory(categoryName: String) async throws -> [Post]
}
