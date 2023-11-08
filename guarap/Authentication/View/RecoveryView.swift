//
//  RecoveryView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 26/10/23.
//

import SwiftUI

struct RecoveryView: View {
    @State private var email = ""
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    @State private var isRecovering = false // Estado para mostrar la pantalla de recuperación de cuenta
    @ObservedObject var networkManager = NetworkManager.shared
    @State private var showNoInternetBanner = false

    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    
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
                    Text("Recover Your Account")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    TextField("Email Address", text: $email)
                        .autocapitalization(.none)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 24)
                        .padding(.top)
                        .onChange(of: email) { newValue in
                            
                            let allowedSymbols = CharacterSet(charactersIn: "!@#$%^&*()-+{}[]~_=\\/?<>.,:;\"\'`")
                            
                            email = newValue.filter { !$0.isWhitespace }
                            
                            email = String(email.unicodeScalars.filter {
                                CharacterSet.alphanumerics.union(allowedSymbols).contains($0)
                            })
                            
                            
                            if newValue.count > MAX_EMAIL_CHAR_LIMIT {
                                email = String(newValue.prefix(MAX_EMAIL_CHAR_LIMIT))
                            }
                        }
                    
                    
                    Button("Submit") {
                        isRecovering = true // Muestra la pantalla de carga
                        Task {
                            do {
                                
                                if networkManager.isOnline {
                                    
                                    try await AuthService.shared.sendPasswordResetEmail(forEmail: email)
                                    
                                    
                                }else {
                                    showNoInternetBanner = true
                                    hideBannerAfterDelay(2)
                                }
                                
                            } catch {
                                // Maneja cualquier error
                            }
                            isRecovering = false // Oculta la pantalla de carga
                        }
                    }
                    
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(guarapColor) // Cambia el color del botón
                    .cornerRadius(10)
                    .padding()
                    
                    Spacer()
                }
                .disabled(isRecovering) // Deshabilita la vista mientras se está procesando la recuperación
                
                if isRecovering {
                    Color.black.opacity(0.5) // Fondo oscuro detrás de la pantalla de carga
                    ProgressView() // Pantalla de carga
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                
                if showNoInternetBanner {
                    BannerView(text: "Currently there is no internet connection.\nTry again later.", color: .yellow)
                }
            }
        }
    }
    
    func hideBannerAfterDelay(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showNoInternetBanner = false
        }
    }
}

struct RecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryView()
    }
}

