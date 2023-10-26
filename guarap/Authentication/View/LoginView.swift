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
    @State private var isLoggingIn = false // Estado para mostrar la pantalla de carga

    
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
                        isLoggingIn = true // Mostrar la pantalla de carga
                        Task {
                            do {
                                try await viewModel.signIn()
                            } catch {
                                // Maneja el error aquí
                            }
                            isLoggingIn = false // Oculta la pantalla de carga después de la autenticación
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(guarapColor)
                    .cornerRadius(10)
                    .padding()
                
                    Text("Forgot your logging details?")
                    
                    NavigationLink{
                        RecoveryView()
                    } label: {
                        Text ("Recover your account" )
                        
                    }
                    Spacer()
                    
                }
                .disabled(isLoggingIn) // Deshabilita la vista mientras se está autenticando
                
                if isLoggingIn {
                    Color.black.opacity(0.5) // Fondo oscuro detrás de la pantalla de carga
                    ProgressView() // Pantalla de carga
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
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
                .padding()
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarHidden(true)
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
