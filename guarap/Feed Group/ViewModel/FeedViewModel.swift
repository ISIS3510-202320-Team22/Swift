//
//  FeedViewModel.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import Foundation
import Firebase
import SwiftUI

class FeedViewModel: ObservableObject {
    @AppStorage("lastCategory") var lastCategory = "Generic"
    @Published var posts = [PostWithImage]()
    @Published var categoryString = "Generic"
    let guarapRepo = GuarapRepositoryImpl.shared
    @ObservedObject var networkManager = NetworkManager.shared

    // Create a cache for posts
    private var postCache = CategoryPostCache()

    init() {
        if lastCategory == "" {
            lastCategory = "Generic"
        }
        categoryString = lastCategory

        // Attempt to fetch posts from cache first
        if let cachedPosts = postCache.getPosts(forCategory: categoryString) {
            posts = cachedPosts
        }

        // Then, update the posts by fetching from the repository
        Task {
            do {
                let fetchedPosts = try await guarapRepo.getPostsByCategory(categoryName: self.categoryString)
                guarapRepo.getPostsWithImages(posts: fetchedPosts) { fetchedPostsWithImages in
                    // Update the posts property
                    self.posts = fetchedPostsWithImages
                    // Store the fetched posts in the cache
                    self.postCache.setPosts(fetchedPostsWithImages, forCategory: self.categoryString)
                    print("Initial")
                }
            } catch {
                // Handle errors
                print("Error fetching posts: \(error)")
            }
        }
    }
    
    @MainActor
    func fetchPosts(category: String) async throws {
        if let cachedPosts = postCache.getPosts(forCategory: category) {
            posts = cachedPosts
            print("Accessing cache")
        } else if networkManager.isOnline {
            let fetchedPosts = try await guarapRepo.getPostsByCategory(categoryName: category)
            guarapRepo.getPostsWithImages(posts: fetchedPosts) { fetchedPostsWithImages in
                self.postCache.setPosts(fetchedPostsWithImages, forCategory: category)
                self.posts = fetchedPostsWithImages
                print("Accessing from web")
            }
            
        } else {
            posts = [PostWithImage]()
        }
    }
    
    @MainActor
    func fetchPostsFromWeb(category: String) async throws {
        do {
            let webPosts = try await guarapRepo.getPostsByCategory(categoryName: category)
            guarapRepo.getPostsWithImages(posts: webPosts) { fetchedPostsWithImages in
                self.postCache.setPosts(fetchedPostsWithImages, forCategory: category)
                self.posts = fetchedPostsWithImages
                print("Get posts directly from the web")
            }
        } catch {
            // Handle errors
            print("Error fetching posts: \(error)")
            print("Error getting directly from web")
        }
    }
}
