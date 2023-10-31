//
//  CreateUsernameView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import SwiftUI

struct CompleteSignUpView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var isCompletingSignUp = false // Estado para mostrar la pantalla de carga
    @State private var showNoConnectionAlert = false
    @State private var showNoInternetBanner = false
    @State private var showErrorAlert = false

    var body: some View {
        NavigationView{
            ZStack{
                VStack(spacing: 12) {
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
                    
                    Text("Welcome to Guarap, \(viewModel.username)!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    Text("Click below to complete registration")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Button("Complete Sign Up") {
                        isCompletingSignUp = true // Mostrar la pantalla de carga
                        Task {
                            do {
                                if networkManager.isOnline {
                                    try await viewModel.createUser() // Este ya maneja errores internamente.
                                    // Lógica para manejar errores o mostrar alertas si es necesario
                                } else {
                                    showNoInternetBanner = true
                                    hideBannerAfterDelay(2)
                                }
                            } catch {
                                print("Unexpected error.")
                            }
                            isCompletingSignUp = false // Ocultar la pantalla de carga después de completar el registro
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 360, height: 44)
                    .background(guarapColor)
                    .cornerRadius(8)
                    
                    .padding(.vertical)
                }
                
                .disabled(isCompletingSignUp) // Deshabilitar la vista mientras se está completando el registro
                
                if isCompletingSignUp {
                    
                    Color.black.opacity(0.5) // Fondo oscuro detrás de la pantalla de carga
                    ProgressView() // Pantalla de carga
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                }
                
                if showNoInternetBanner {
                    BannerView(text: "Currently there is no internet connection.\nTry again later.", color: .yellow)
                }
                
                if showErrorAlert {
                    BannerView(text: "Error occurred while completing registration. Please try again.", color: .red)
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func hideBannerAfterDelay(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showNoInternetBanner = false
            showErrorAlert = false
        }
    }
    
}


struct CompleteSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSignUpView()
    }
}
