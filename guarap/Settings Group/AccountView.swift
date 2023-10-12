//
//  ProfileView.swift
//  guarap
//
//  Created by Nathalia Quiroga 2/10/23.
//

import SwiftUI

struct AccountView: View {
    

    
    var body: some View {
        NavigationStack {
            VStack{
                HStack {
                    Spacer()
                    
                    Button{
                        AuthService.shared.signOut()
                    } label: {
                        Text("Sign Out")
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
                        Text("---")
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

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
