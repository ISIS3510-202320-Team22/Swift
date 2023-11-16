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
    static let userDao: UserDAO = UserDAOFirebase.shared
    static let bugReportDao: BugReportDAO = BugReportDAOFirebase.shared
    
    func createPost(description: String, image: UIImage?, category: String, address: String, completion: @escaping (Bool) -> Void) {
        
        guard category != "" else {
            createPost(description: description, image: image, category: DEFAULT_CATEGORY, address: address, completion: completion)
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
                    
                    GuarapRepositoryImpl.postDao.createPost(description: description, imageUrl: imageUrlString, category: category, address: address) { result in
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
            GuarapRepositoryImpl.postDao.createPost(description: description, imageUrl: "", category: category, address: address) { result in
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
    
    func getPostsWithImages(posts: [Post], completion: @escaping ([PostWithImage]) -> Void) {
        var postsWithImages = [PostWithImage]()
        let dispatchGroup = DispatchGroup() // Create a dispatch group

        for post in posts {
            dispatchGroup.enter() // Enter the dispatch group
            GuarapRepositoryImpl.shared.getImageFromUrl(url: post.image) { image in
                postsWithImages.append(PostWithImage(id: post.id, user: post.user, description: post.description, upVotes: post.upVotes, downVotes: post.downVotes, reported: post.reported, image: post.image, address: post.address, dateTime: post.dateTime, uiimage: image))
                dispatchGroup.leave() // Leave the dispatch group when the image is fetched
            }
        }

        dispatchGroup.notify(queue: .main) {
            // All images have been fetched, call the completion handler
            completion(postsWithImages)
        }
    }
    
    func sendBugReport(title: String, description: String, completion: @escaping (Bool) -> Void) {
        GuarapRepositoryImpl.bugReportDao.sendBugReport(title: title, description: description, completion: completion)
    }
}
