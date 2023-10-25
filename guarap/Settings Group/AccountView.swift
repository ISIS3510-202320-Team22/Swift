//
//  ProfileView.swift
//  guarap
//
//  Created by Nathalia Quiroga 2/10/23.
//

import SwiftUI

struct AccountView: View {
    
    @AppStorage("username") var username = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    Spacer()
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
                    
                    VStack(alignment: .center) { // Añade alignment: .center aquí
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 200, height: 200)
                        Text(username)
                            .font(.system(size: 30))
                    }
                    
                    Spacer()
                }
            }
        }
    }
}


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
