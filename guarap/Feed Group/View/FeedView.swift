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
    
    // Dropdown Menu States
    @State private var isPopoverVisible = false
    @State private var selectedOption: String = "Select a Category"
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    isPopoverVisible.toggle()
                }) {
                    Text(selectedOption)
                }
                .popover(isPresented: $isPopoverVisible, arrowEdge: .top) {
                    List {
                        ForEach(categories, id: \.self) { option in
                            Button(action: {
                                selectedOption = option
                                lastCategory = option
                                isPopoverVisible.toggle()
                            }) {
                                Text(option)
                            }
                        }
                    }.foregroundColor(.black)
                }
            }
            
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
            .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                .onChange(of: viewModel.categoryString) { newValue in
                                if newValue.count > MAX_CATEGORY_CHAR_LIMIT {
                                    viewModel.categoryString = String(newValue.prefix(MAX_CATEGORY_CHAR_LIMIT))
                                }
                            }
                
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
