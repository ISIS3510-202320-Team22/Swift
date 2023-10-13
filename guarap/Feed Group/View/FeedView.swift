//
//  FeedView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 25/09/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @AppStorage("lastCategory") var lastCategory = "Generic"
    
    var body: some View {
        NavigationStack {
            TextField("Category", text: $viewModel.categoryString, onCommit: {
                Task {
                    do {
                        if viewModel.categoryString == "" {
                            viewModel.categoryString  = "Generic"
                        }
                        lastCategory = viewModel.categoryString
                        try await viewModel.fetchPosts(category: viewModel.categoryString)
                    } catch {
                        print("Error fetching posts: \(error.localizedDescription)")
                    }
                }
            })
                .padding()
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
            ScrollView {
                LazyVStack(spacing: 30) {
                    ForEach(viewModel.posts) { post in
                        FeedCell(post: post)
                    }
                }
            }
            .navigationTitle("Guarap")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // Fetch posts when the view first appears
            Task {
                do {
                    try await viewModel.fetchPosts(category: viewModel.categoryString)
                } catch {
                    print("Error fetching posts: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
