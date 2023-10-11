//
//  FeedViewModel.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import Foundation
import Firebase
import FirebaseFirestore.FIRGeoPoint

class FeedViewModel: ObservableObject{
    @Published var posts = [Post]()
    let guarapRepo = GuarapRepositoryImpl.shared
    
    init(){
        Task{ try await fetchPosts()}
    }
    
    @MainActor
    func fetchPosts() async throws{
        posts = try await guarapRepo.getPostsByCategory(categoryName: "atardeceres")
    }
}
