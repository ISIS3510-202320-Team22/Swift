//
//  CategoryPostCache.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 29-10-2023.
//

import Foundation

class CategoryPostCache {
    var cache = [String: [PostWithImage]]()

    func setPosts(_ posts: [PostWithImage], forCategory category: String) {
        cache[category] = posts
    }

    func getPosts(forCategory category: String) -> [PostWithImage]? {
        return cache[category]
    }

    func clearCache() {
        cache.removeAll()
    }
}
