//
//  FeedView.swift
//  guarap
//
//  Created by Juan Diego Calixto on 25/09/23.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                    }
                    .padding()
                    Spacer()
                    
                    NavigationLink(destination: PublishView()) {
                        Text("Post")
                    }
                    .padding()
                }
                Text("Guarap")
                    .font(.title)
                HStack{
                    Text("Fotografias")
                        .frame(width:75,height:25)
                        .foregroundColor(Color.black)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .font(.system(size: 10))
                    
                    Text("Chisme")
                        .frame(width:75,height:25)
                        .foregroundColor(Color.black)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .font(.system(size: 10))
                    
                    Text("Looking for")
                        .frame(width:75,height:25)
                        .foregroundColor(Color.black)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .font(.system(size: 10))
                    
                    Text("Trabajos")
                        .frame(width:75,height:25)
                        .foregroundColor(Color.black)
                        .background(Color.gray)
                        .cornerRadius(15)
                        .font(.system(size: 10))
                }
                HStack{
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 60, height: 60, alignment: .topLeading)
                    VStack(alignment: .leading){
                        Text("@juandicanu202")
                            .font(.system(size: 30))
                        Text("25/10 4:06pm")
                            .font(.system(size: 15))
                    }
                    Spacer()
                }.padding(EdgeInsets(top: 5, leading: 30, bottom: 5, trailing: 20))
                Spacer()
            }
        }
    }
}

#Preview {
        FeedView()
}
