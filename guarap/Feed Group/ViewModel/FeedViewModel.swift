//
//  FeedViewModel.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import Foundation
import Firebase

class FeedViewModel: ObservableObject{
    @Published var posts = [Post]()
    
    init(){
        Task{ try await fetchPosts()}
    }
    
    func fetchPosts() async throws{
        let snapshot = try await Firestore.firestore().collection("posts").getDocuments()
        self.posts = try snapshot.documents.compactMap({ try $0.data(as: Post.self)})
    }
}
