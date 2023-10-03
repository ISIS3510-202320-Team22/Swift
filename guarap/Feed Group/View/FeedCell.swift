//
//  FeedCell.swift
//  guarap
//
//  Created by Juan Diego Calixto on 3/10/23.
//

import SwiftUI

struct FeedCell: View {
    let post : Post
    var body: some View {
        VStack{
            // Image and username + publishing time
            HStack{
                Image("avatar")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height:60)
                    .clipShape(Circle())
                VStack(alignment: .leading){
                    Text("@juandicanu202")
                        .font(.system(size: 20))
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text("25/10 4:06pm")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }.padding(.leading)
            
            // Post
            
            Image(post.image)
                .resizable()
                .scaledToFill()
                .frame(height: 400)
                .cornerRadius(15)
                .clipShape(Rectangle())
                .padding(15)
            
            // Action buttons
            
            HStack(spacing: 20){
                // arrowtriangle.up.circle.fill
                // hand.thumbsup.fill
                // arrow.up.heart.fill
                Spacer()
                Button{
                    print("Up post")
                } label: {
                    Image(systemName: "arrow.up.heart.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height:35)
                }
                Button{
                    print("Up post")
                } label: {
                    Image(systemName: "arrow.down.heart.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 35, height:35)
                }
                
            }.padding(.trailing)
                .foregroundColor(.black)
            
            // Comments
            Text(post.title)
            Text(post.description)
            HStack{
                Text("@sadiomane ").fontWeight(.semibold) +
                Text("Grande calixx")
            }
            .frame(maxWidth: .infinity, alignment:.leading)
            .font(.footnote)
            .padding(.leading,15)
            .padding(.top,1)
        }
    }
}

struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedCell()
    }
}
