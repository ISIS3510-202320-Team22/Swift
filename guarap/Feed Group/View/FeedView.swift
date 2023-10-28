//
//  FeedView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 25/09/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    @AppStorage("lastCategory") var lastCategory = DEFAULT_CATEGORY
    
    // Dropdown Menu States
    @State private var isPopoverVisible = false
    
    var body: some View {
        NavigationStack {
            Button(action: {
                isPopoverVisible.toggle()
            }) {
                Text(lastCategory)
            }
            .popover(isPresented: $isPopoverVisible, arrowEdge: .top) {
                List {
                    ForEach(categories, id: \.self) { option in
                        Button(action: {
                            lastCategory = option
                            viewModel.categoryString = option
                            isPopoverVisible.toggle()
                            
                            Task {
                                do {
                                    if viewModel.categoryString == "" {
                                        viewModel.categoryString = "Generic"
                                    }
                                    lastCategory = viewModel.categoryString
                                    try await viewModel.fetchPosts(category: viewModel.categoryString)
                                } catch {
                                    print("Error fetching posts: \(error.localizedDescription)")
                                }
                            }
                        }) {
                            Text(option)
                        }.foregroundColor(.red)
                    }
                }.foregroundColor(.black)
            }
            
            ScrollView {
                if !viewModel.posts.isEmpty {
                    LazyVStack(spacing: 30) {
                        ForEach(viewModel.posts) { post in
                            FeedCell(post: post, category: lastCategory)
                        }
                    }
                } else {
                    Spacer()
                    Text("There is nothing in this category for now")
                        .padding()
                    Spacer()
                }
                
            }
            .navigationTitle("Guarap")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                do {
                    // This is the action to refresh the data
                    try await viewModel.fetchPosts(category: viewModel.categoryString)
                } catch {
                    print("Error fetching posts: \(error.localizedDescription)")
                }
            }
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
