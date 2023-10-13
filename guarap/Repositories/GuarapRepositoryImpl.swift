//
//  GuarapRepositoryImpl.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI

class GuarapRepositoryImpl: GuarapRepository {
    
    private init(){}
    
    static var shared: GuarapRepository = GuarapRepositoryImpl()
    
    static let postDao: PostDAO = PostDAOFirebase.shared
    static let imageDao: ImageDAO = ImageDAOFirebase.shared
    
    func createPost(description: String, image: UIImage?, category: String, latitude: Double, longitude: Double) async throws -> Bool {
        
        guard category != "" else {
            return try await createPost(description: description, image: image, category: "Generic", latitude: latitude, longitude: longitude)
        }
        
        var success = false
        if let img = image {
            GuarapRepositoryImpl.imageDao.uploadImageToFirebase(image: img) { result in
                switch result {
                case .success(let url):
                    // The image was successfully uploaded, and the URL is in the 'url' variable.
                    // You can proceed with creating the post here.
                    let imageUrlString = url.absoluteString
                    
                    // Now create the post with the image URL and other data.
                    GuarapRepositoryImpl.postDao.createPost(description: description, imageUrl: imageUrlString, category: category, latitude: latitude, longitude: longitude) { result in
                        success = result
                    }
                    
                case .failure(let error):
                    // Handle the error if the image upload fails.
                    print("Error uploading image: \(error)")
                    
                }
            }
        }
        
        return success
    }
    
    func getPostsByCategory(categoryName: String) async throws -> [Post] {
        print(1)
        print(categoryName)
        print(1)
        return try await GuarapRepositoryImpl.postDao.getPostsByCategory(categoryName: categoryName)
    }
    
    func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void) {
        GuarapRepositoryImpl.imageDao.getImageFromUrl(url: url, completion: completion)
    }
}
