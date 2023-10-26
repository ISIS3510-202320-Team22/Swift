//
//  FeedCell.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import SwiftUI
import Firebase

struct FeedCell: View {
    @State var downloadedImage: UIImage?
    
    @State private var isLiked = false
    @State private var isDisliked = false
    
    
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    
    var guarapRepo = GuarapRepositoryImpl.shared
    let post : Post
    let category: String
    
    var body: some View {
        VStack(alignment: .leading){
            // Image and username + publishing time
            HStack{
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
            }.padding(.leading)
            
            if let image = downloadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 400)
                    .cornerRadius(15)
                    .clipShape(Rectangle())
                    .padding(15)
            }
            
            // Action buttons
            let categoryRef = Firestore.firestore().collection("categories").document(category)
            let postRef = categoryRef.collection("posts").document(post.id.uuidString)

            HStack(spacing: 20) {
                Spacer()

                Button(action: {
                    if isLiked {
                        // Unlike post
                        postRef.updateData([
                            "upVotes": FieldValue.increment(Int64(-1)) // Specify the type explicitly
                        ])
                    } else {
                        // Like post
                        postRef.updateData([
                            "upVotes": FieldValue.increment(Int64(1)) // Specify the type explicitly
                        ])
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

                Text(String(post.upVotes))
                    .font(.system(size: 10))
                    .padding(.bottom)

                Button(action: {
                    if isDisliked {
                        // Undislike post
                        postRef.updateData([
                            "downVotes": FieldValue.increment(Int64(-1)) // Specify the type explicitly
                        ])
                    } else {
                        // Dislike post
                        postRef.updateData([
                            "downVotes": FieldValue.increment(Int64(1)) // Specify the type explicitly
                        ])
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

                Text(String(post.downVotes))
                    .font(.system(size: 10))
                    .padding(.bottom)
            }.padding(.trailing)
             .foregroundColor(.black)

            
            // Comments
            Text(post.description)
                .padding(.leading,15)
            HStack{
                Text("@sadiomane ").fontWeight(.semibold) +
                Text("Grande calixx")
            }
            .frame(maxWidth: .infinity, alignment:.leading)
            .font(.footnote)
            .padding(.leading,15)
            .padding(.top,1)
            .onAppear {
                // Fetch the image when the view appears
                if !post.image.isEmpty {
                    guarapRepo.getImageFromUrl(url: post.image) { image in
                        // Update the downloadedImage state when the image is fetched
                        downloadedImage = image
                    }
                }
            }
        }
    }
    
    func formatTime(_ time: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - HH:mm"
        return dateFormatter.string(from: time)
    }
}

//struct FeedCell_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedCell(post: <#Post#>)
//    }
//}
