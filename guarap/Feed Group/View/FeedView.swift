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
    
    @ObservedObject var networkManager = NetworkManager.shared
    
    @State var textWhenEmpty = Text("")
    
    
    var body: some View {
        NavigationStack {
            Spacer()
            HStack {
                if networkManager.isConnectionBad {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.yellow)
                            .padding(.leading)
                    Text("Slow connection")
                }
                
                if !networkManager.isOnline {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .padding(.leading)
                    Text("No connection")
                }
                
                Spacer()
                Text("Category:")
                Button(action: {
                    isPopoverVisible.toggle()
                }) {
                    HStack {
                        Text(lastCategory)
                        Image(systemName: "chevron.down")
                    }
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
                    }
                    .foregroundColor(.black)
                }
                
                Spacer()
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
                    textWhenEmpty.padding()
                    Spacer()
                }
                
            }
            .refreshable {
                do {
                    // This is the action to refresh the data
                    if networkManager.isOnline {
                        textWhenEmpty = Text("There is nothing in this category for now")
                        try await viewModel.fetchPosts(category: viewModel.categoryString)
                    } else {
                        textWhenEmpty = Text("Currently there is no internet connetion so we cannot fetch any new posts")
                    }
                } catch {
                    print("Error fetching posts: \(error.localizedDescription)")
                }
            }
        }
        .onAppear {
            // Fetch posts when the view first appears
            Task {
                do {
                    if networkManager.isOnline {
                        textWhenEmpty = Text("There is nothing in this category for now")
                        try await viewModel.fetchPosts(category: viewModel.categoryString)
                    } else {
                        textWhenEmpty = Text("Currently there is no internet connetion so we cannot fetch any new posts")
                    }
                    
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
