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
    @State var downloadedImage: UIImage?
    
    @State private var isLiked = false
    @State private var isDisliked = false
    @State private var upVotes: Int
    @State private var downVotes: Int
    
    private let userDefaults = UserDefaults.standard
    
    init(post: PostWithImage, category: String) {
        self.post = post
        self.category = category
        self._upVotes = State(initialValue: post.upVotes)
        self._downVotes = State(initialValue: post.downVotes)
        
        // Check if the user has previously liked or disliked this post
        self._isLiked = State(initialValue: userDefaults.bool(forKey: "\(post.id)_liked"))
        self._isDisliked = State(initialValue: userDefaults.bool(forKey: "\(post.id)_disliked"))
    }
    
    
    let firestore = Firestore.firestore()
    
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    
    @StateObject var viewModel = FeedViewModel()
    var guarapRepo = GuarapRepositoryImpl.shared
    
    // Properties passed by FeedView
    let post : PostWithImage
    let category: String
    
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
                    // UNLIKING
                    if !isLiked {
                        viewModel.updateLikes(for: post, num: 1, cat: category)
                        upVotes += 1
                        userDefaults.setValue(true, forKey: "\(post.id)_liked")
                        
                        // If the post was previously disliked, undo the dislike
                        if isDisliked {
                            viewModel.updateDislikes(for: post, num: -1, cat: category)
                            downVotes -= 1
                            userDefaults.removeObject(forKey: "\(post.id)_disliked")
                        }
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
                    // UNDISLIKING
                    if !isDisliked {
                        viewModel.updateDislikes(for: post, num: 1, cat: category)
                        downVotes += 1
                        userDefaults.setValue(true, forKey: "\(post.id)_disliked")
                        
                        // If the post was previously liked, undo the like
                        if isLiked {
                            viewModel.updateLikes(for: post, num: -1, cat: category)
                            upVotes -= 1
                            userDefaults.removeObject(forKey: "\(post.id)_liked")
                        }
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
