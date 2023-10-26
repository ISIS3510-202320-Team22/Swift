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
    
    func createPost(description: String, image: UIImage?, category: String, latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        
        guard category != "" else {
            createPost(description: description, image: image, category: "Generic", latitude: latitude, longitude: longitude, completion: completion)
            return
        }
        
        var success = false
        
        if description == "" && image == nil {
            completion(success)
            return
        }
        
        if let img = image {
            GuarapRepositoryImpl.imageDao.uploadImageToFirebase(image: img) { result in
                switch result {
                case .success(let url):
                    // The image was successfully uploaded, and the URL is in the 'url' variable.
                    // You can proceed with creating the post here.
                    let imageUrlString = url.absoluteString
                    
                    GuarapRepositoryImpl.postDao.createPost(description: description, imageUrl: imageUrlString, category: category, latitude: latitude, longitude: longitude) { result in
                        success = result
                        completion(success) // Call the completion closure with the result
                        return
                    }
                    
                case .failure(let error):
                    // Handle the error if the image upload fails.
                    print("Error uploading image: \(error)")
                    completion(success) // Call the completion closure with the result
                    return
                }
            }
        } else if image == nil {
            GuarapRepositoryImpl.postDao.createPost(description: description, imageUrl: "", category: category, latitude: latitude, longitude: longitude) { result in
                success = result
                completion(success) // Call the completion closure with the result
                return
            }
        }
    }

    
    func getPostsByCategory(categoryName: String) async throws -> [Post] {
        return try await GuarapRepositoryImpl.postDao.getPostsByCategory(categoryName: categoryName)
    }
    
    func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void) {
        GuarapRepositoryImpl.imageDao.getImageFromUrl(url: url, completion: completion)
    }
}
