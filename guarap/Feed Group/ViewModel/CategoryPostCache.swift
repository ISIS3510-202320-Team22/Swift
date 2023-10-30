//
//  CategoryPostCache.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 29-10-2023.
//

import Foundation

class CategoryPostCache {
    var cache = [String: [Post]]()

    func setPosts(_ posts: [Post], forCategory category: String) {
        cache[category] = posts
    }

    func getPosts(forCategory category: String) -> [Post]? {
        return cache[category]
    }

    func clearCache() {
        cache.removeAll()
    }
}
