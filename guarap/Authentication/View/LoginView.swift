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
    
    var body: some View {
        NavigationView{
            ZStack{
                
                VStack{
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
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding()
                    
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
