//
//  FeedCell.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import SwiftUI
import Firebase
import Foundation

struct FeedCell: View {
    
    let firestore = Firestore.firestore()
    var guarapRepo = GuarapRepositoryImpl.shared
    
    @StateObject var viewModel = FeedViewModel()
    
    @State var downloadedImage: UIImage?
    
    @State private var isLiked = false
    @State private var isDisliked = false
    @State private var upVotes: Int
    @State private var downVotes: Int
    
    private let userDefaults = UserDefaults.standard
    private let likedPostsKey = "likedPosts"
    private let dislikedPostsKey = "dislikedPosts"
        
    // Properties passed by FeedView
    let post : PostWithImage
    let category: String
    
    init(post: PostWithImage, category: String, isLiked: Bool, isDisliked: Bool) {
        self.post = post
        self.category = category
        self._upVotes = State(initialValue: post.upVotes)
        self._downVotes = State(initialValue: post.downVotes)
        
        self._isLiked = State(initialValue: isLiked)
        self._isDisliked = State(initialValue: isDisliked)
        
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Image and username + publishing time
            HStack {
                Image("avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height:60)
                    .clipShape(Circle())
                VStack(alignment: .leading){
                    Text(post.user)
                        .font(.system(size: 20))
                        .font(.footnote)
                        .fontWeight(.semibold)
                    if let formattedTime = formatTime(post.dateTime) {
                        Text(formattedTime)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
            }
            .padding(.leading)
            
            if let image = downloadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 400)
                    .cornerRadius(15)
                    .clipShape(Rectangle())
                    .padding(15)
            }
            
            Text(post.description)
                .padding(.leading,15)
            HStack(spacing: 20) {
                // Comments
                
                Spacer()
                
                //
                // LIKING BUTTON
                //
                
                Button(action: {
                    let postId = post.id.uuidString
                    
                    // Is already liked and you are unliking it
                    if isLiked {
                        viewModel.updateLikes(for: post, num: -1, cat: category)
                        upVotes -= 1
                        
                        // Remove liked post ID from UserDefaults
                        var likedPosts = Set(userDefaults.stringArray(forKey: likedPostsKey) ?? [])
                        likedPosts.remove(postId)
                        userDefaults.set(Array(likedPosts), forKey: likedPostsKey)
                    }
                    // First time liking it
                    else
                    {
                        // If the post was previously disliked, undo the dislike
                        if isDisliked {
                            viewModel.updateDislikes(for: post, num: -1, cat: category)
                            downVotes -= 1
                            
                            // Remove disliked post ID from UserDefaults
                            var dislikedPosts = Set(userDefaults.stringArray(forKey: dislikedPostsKey) ?? [])
                            dislikedPosts.remove(postId)
                            userDefaults.set(Array(dislikedPosts), forKey: dislikedPostsKey)
                        }
                        // Like
                        viewModel.updateLikes(for: post, num: 1, cat: category)
                        upVotes += 1
                        
                        // Save liked post ID to UserDefaults
                        var likedPosts = Set(userDefaults.stringArray(forKey: likedPostsKey) ?? [])
                        likedPosts.insert(postId)
                        userDefaults.set(Array(likedPosts), forKey: likedPostsKey)
                        
                    }
                    isLiked.toggle()
                    
                    // Also, reset isDisliked when liking a post
                    isDisliked = false
                }) {
                    Image(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .foregroundColor(isLiked ? guarapColor: .gray)
                }
                
                Text(String(upVotes))
                    .font(.system(size: 10))
                    .padding(.bottom)
                    .foregroundColor(Color.secondary)
                    .colorMultiply(Color.primary)
                
                
                //
                // DISLIKING BUTTON
                //
                
                
                Button(action: {
                    let postId = post.id.uuidString
                    // Is already disliked and you are undisliking it
                    if isDisliked {
                        viewModel.updateDislikes(for: post, num: -1, cat: category)
                        downVotes -= 1
                        
                        // Remove disliked post ID from UserDefaults
                        var dislikedPosts = Set(userDefaults.stringArray(forKey: dislikedPostsKey) ?? [])
                        dislikedPosts.remove(postId)
                        userDefaults.set(Array(dislikedPosts), forKey: dislikedPostsKey)
                    }
                    // First time disliking it
                    else
                    {
                        // If the post was previously liked, undo de like
                        if isLiked {
                            viewModel.updateLikes(for: post, num: -1, cat: category)
                            upVotes -= 1
                            
                            // Remove liked post ID from UserDefaults
                            var likedPosts = Set(userDefaults.stringArray(forKey: likedPostsKey) ?? [])
                            likedPosts.remove(postId)
                            userDefaults.set(Array(likedPosts), forKey: likedPostsKey)
                        }
                        // Dislike
                        viewModel.updateDislikes(for: post, num: 1, cat: category)
                        downVotes += 1
                        
                        // Save disliked post ID to UserDefaults
                        var dislikedPosts = Set(userDefaults.stringArray(forKey: dislikedPostsKey) ?? [])
                        dislikedPosts.insert(postId)
                        userDefaults.set(Array(dislikedPosts), forKey: dislikedPostsKey)
                        
                    }
                    
                    isDisliked.toggle()
                    
                    // Also, reset isLiked when disliking a post
                    isLiked = false
                }) {
                    Image(systemName: isDisliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height: 35)
                        .foregroundColor(isDisliked ? guarapColor: .gray)
                }
                
                Text(String(downVotes))
                    .font(.system(size: 10))
                    .padding(.bottom)
                    .foregroundColor(Color.secondary)
                    .colorMultiply(Color.primary)
            }
            .padding(.trailing)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment:.leading)
            //.font(.footnote)
            .padding(.leading,15)
            .padding(.top,1)
        }
        .onAppear {
            // Fetch the image when the view appears
            if !post.image.isEmpty {
                downloadedImage = post.uiimage
            }
        }
    }
    
    func formatTime(_ time: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
        return dateFormatter.string(from: time)
    }
}
