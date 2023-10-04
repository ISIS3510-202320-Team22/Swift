//
//  PostDAOImpl.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 03-10-2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore.FIRGeoPoint

class PostDAOFirebase: PostDAO {
    
    private init(){}
    
    static var shared: PostDAO = PostDAOFirebase()
    
    func createPost(title: String, description: String, image: Image?, category: String) {
        // implement logic here
    }
    
    @MainActor
    func getPostsByCategory(categoryName: String) async throws -> [Post] {
        var posts = [Post]()
        let snapshot = Firestore.firestore().collection("categories").document("atardeceres").collection("posts")
        
        do {
            let queryPosts = try await snapshot.getDocuments()
            for document in queryPosts.documents {
                let postDict = document.data()
                
                do {
                    if let user = postDict["user"] as? String,
                       let title = postDict["title"] as? String,
                       let description = postDict["description"] as? String,
                       let upVotes = postDict["upVotes"] as? Int,
                       let downVotes = postDict["downVotes"] as? Int,
                       let reported = postDict["reported"] as? Bool {
                        
                        var image = ""
                        if let unwrappedImage = postDict["image"] as? String {
                            image = unwrappedImage
                        }
                        
                        var latitude = 0.0
                        var longitude = 0.0
                        if let location = postDict["location"] as? GeoPoint {
                            latitude = location.latitude
                            longitude = location.longitude
                        }


                        let post = Post(id: UUID(), user: user, title: title, description: description, upVotes: upVotes, downVotes: downVotes, reported: reported, image: image, latitude: latitude, longitude: longitude)
                            
                            posts.append(post)
                    }
                }
            }
        }
        
        return posts
    }
}
