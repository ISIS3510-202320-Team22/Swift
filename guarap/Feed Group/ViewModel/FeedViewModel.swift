//
//  FeedViewModel.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import Foundation
import Firebase
import SwiftUI

class FeedViewModel: ObservableObject{
    @AppStorage("lastCategory") var lastCategory = "Generic"
    @Published var posts = [Post]()
    @Published var categoryString = "Generic"
    let guarapRepo = GuarapRepositoryImpl.shared
    
    init(){
        if lastCategory == "" {
            lastCategory = "Generic"
        }
        categoryString = lastCategory
        Task{ try await fetchPosts(category: categoryString)}
    }
    
    @MainActor
    func fetchPosts(category: String) async throws{
        posts = try await guarapRepo.getPostsByCategory(categoryName: category)
    }
}
