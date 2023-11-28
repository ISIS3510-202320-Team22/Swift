//
//  LoginView.swift
//  guarap
//
//  Created by Nathalia Quiroga 2/10/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    @State private var isLoggingIn = false // Estado para mostrar la pantalla de carga
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var showNoConnectionAlert = false
    @State private var showNoInternetBanner = false
    @State private var showErrorAlert = false
    
    @State var showNext = false
    
    @AppStorage("creatingProfile") var creatingProfile = true
    
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    if networkManager.isConnectionBad {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                                .padding(.leading)
                        Text("Slow connection")
                    }
                    
                    if !networkManager.isOnline {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .padding(.leading)
                        Text("No connection")
                       
                    }

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
                                if networkManager.isOnline {
                                    await viewModel.signIn() // Este ya maneja errores internamente.
                                    if viewModel.didFailSignIn {
                                        print("LOGIN INCORRECTO")
                                        showErrorAlert = true
                                        hideBannerAfterDelay(2)
                                        viewModel.didFailSignIn = false // Resetearlo para futuros intentos.
                                    }
                                } else {
                                    showNoInternetBanner = true
                                    hideBannerAfterDelay(2)
                                }
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
                    
                    if networkManager.isOnline {
                        NavigationLink(destination: RecoveryView()) {
                            Text("Recover your account")
                        }
                    } else {
                        Button("Recover your account") {
                            showNoInternetBanner = true
                            hideBannerAfterDelay(3)
                        }
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
                    
                    if networkManager.isOnline {
                        NavigationLink(destination: AddEmailView(showing: $showNext), isActive: $showNext) {
                            Button(action: {
                                showNext = true
                            }) {
                                Text("Create Account")
                            }
                        }
                    } else {
                        Button("Create Account") {
                            showNoInternetBanner = true
                            hideBannerAfterDelay(3)
                        }
                    }
                }
                .padding()
                
                if showNoInternetBanner {
                    BannerView(text: "Currently there is no internet connection.\nTry again later.", color: .yellow)
                }
                
                if showErrorAlert {
                    BannerView(text: "Incorrect email or password. Please try again.", color: .red)
                }
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarHidden(true)
        .onChange(of: showNext) { result in
            if !creatingProfile {
                creatingProfile = true
            }
        }
        .onAppear() {
            showNext = false
        }
        
    }
    
    func hideBannerAfterDelay(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showNoInternetBanner = false
            showErrorAlert = false
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
