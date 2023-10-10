//
//  LoginView.swift
//  guarap
//
//  Created by Nathalia Quiroga 2/10/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUser = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    
    var body: some View {
        NavigationView{
            ZStack{
                
                VStack{
                    Text("Guarap")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    TextField("Email Addess", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .border(Color.gray, width: 1)
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUser))
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .border(Color.gray, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    Button("Login") {
                        authenticateUser(username: username, password: password)
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding()
                    
                    NavigationLink(destination: AccountView(), isActive: $showingLoginScreen)
                    {
                        EmptyView()
                            .navigationBarBackButtonHidden()
                    }
                    
                    Text("Forgot your logging details?")
                    Button("Recover your account"){
                        
                    }
                }
                VStack{
                    Text("Don't have an account?")
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    NavigationLink{
                        AddEmailView()
                    } label: {
                        Text ("Create Account" )
                        
                    }
                }
            }
        }
        .navigationBarHidden(true)
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
            
        }
    }
    
    func authenticateUser(username: String, password: String){
        if username.lowercased() == "hola" {
            wrongUser = 0
            if password.lowercased() == "hola"{
                wrongPassword = 0
                showingLoginScreen = true
            } else {
                wrongPassword = 2
            }
        } else {
            wrongUser = 2
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
