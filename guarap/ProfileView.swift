//
//  ProfileView.swift
//  guarap
//
//  Created by Nathalia Quiroga.
//

import SwiftUI

struct ProfileView: View {
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
    
                ZStack{
                    
                    VStack(alignment: .center){
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 200, height: 200, alignment: .topLeading)
                        Text("@juandicanu202")
                            .font(.system(size: 30))
                        Text("Favorite Categories")
                            .font(.system(size: 25))
                            .bold()
                            .padding()
                        Button("Category 1"){
                
                        }
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color.red)
                        .cornerRadius(10)
                        Button("Category 2"){
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color.red)
                        .cornerRadius(10)
                        Button("Category 3"){
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color.red)
                        .cornerRadius(10)
                        Button("Category 4"){
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 200, height: 60)
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                }
                Spacer()
            }
        }
    }
}



