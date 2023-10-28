//
//  PostDAOImpl.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI
import Firebase

class PostDAOFirebase: PostDAO {
    //@AppStorage("userUID") var userUID = ""
    @AppStorage("username") var username = ""
    
    private init(){}
    
    static var shared: PostDAO = PostDAOFirebase()
    
    func createPost(description: String, imageUrl: String, category: String, address: String, completion: @escaping (Bool) -> Void) {
        let firestore = Firestore.firestore()

        let user = username // Replace with actual user data
        let upVotes = 0
        let downVotes = 0
        let reported = false
        let dateTime = Date()

        firestore.runTransaction({ transaction, errorPointer in
            let categoryRef = firestore.collection("categories").document(category)

            do {
                // Try to retrieve the category document
                let categoryDocument = try transaction.getDocument(categoryRef)

                if !categoryDocument.exists {
                    // If the category doesn't exist, create it
                    let initialCategoryData: [String: Any] = [
                        "name": category
                    ]
                    transaction.setData(initialCategoryData, forDocument: categoryRef)
                }

                // Create the post and add it to the category
                let postRef = categoryRef.collection("posts").document()
                let postAttributes: [String: Any] = [
                    "user": user,
                    "description": description,
                    "upvotes": upVotes,
                    "downvotes": downVotes,
                    "reported": reported,
                    "image": imageUrl,
                    "address": address,
                    "date": Timestamp(date: dateTime)
                ]
                transaction.setData(postAttributes, forDocument: postRef)

                completion(true)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                completion(false)
            }

            return nil
        }) { _, error in
            if let error = error {
                print("Transaction failed: \(error)")
                completion(false)
            }
        }
    }
    
    @MainActor
    func getPostsByCategory(categoryName: String) async throws -> [Post] {
        var posts = [Post]()
        let snapshot = Firestore.firestore().collection("categories").document(categoryName).collection("posts")
        
        do {
            let queryPosts = try await snapshot.getDocuments()
            for document in queryPosts.documents {
                let postDict = document.data()
                
                do {
                    if let user = postDict["user"] as? String,
                       let description = postDict["description"] as? String,
                       let upVotes = postDict["upvotes"] as? Int,
                       let downVotes = postDict["downvotes"] as? Int,
                       let reported = postDict["reported"] as? Bool,
                       let address = postDict["address"] as? String,
                       let dateTime = postDict["date"] as? Timestamp {
                        
                        var image = ""
                        if let unwrappedImage = postDict["image"] as? String {
                            image = unwrappedImage
                        }

                        let post = Post(id: UUID(), user: user, description: description, upVotes: upVotes, downVotes: downVotes, reported: reported, image: image, address: address, dateTime: dateTime.dateValue())
                            
                            posts.append(post)
                    }
                }
            }
        }
        
        return posts
    }
}
