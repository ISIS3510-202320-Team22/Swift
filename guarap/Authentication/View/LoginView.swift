//
//  LoginView.swift
//  guarap
//
//  Created by Nathalia Quiroga 2/10/23.
//

import SwiftUI

struct LoginView: View {

    @State private var showingLoginScreen = false
    @StateObject var viewModel = LoginViewModel()
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    
    
    var body: some View {
        NavigationView{
            ZStack{
                
                VStack{
                    Spacer()
                    Text("Guarap")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    TextField("Email Addess", text: $viewModel.email)
                        .autocapitalization(.none)
                        .font (.subheadline)
                        .padding (12)
                        .background (Color(.systemGray6))
                        .cornerRadius (10)
                        .padding (.horizontal, 24)
                        .padding (.top)
                    SecureField("Password", text: $viewModel.password)
                        .autocapitalization(.none)
                        .font (.subheadline)
                        .padding (12)
                        .background (Color(.systemGray6))
                        .cornerRadius (10)
                        .padding (.horizontal, 24)
                        .padding (.top)
                    Button("Login") {
                        Task { try await viewModel.signIn()}
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(guarapColor)
                    .cornerRadius(10)
                    .padding()
                    
                    Text("Forgot your logging details?")
                    Button("Recover your account"){
                        
                    }
                    
                    Spacer()
                }
                
                VStack{
                    
                    Spacer()
                    Text("Don't have an account?")
                    
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
