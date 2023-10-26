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

    var body: some View {
        NavigationView {
            VStack {
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
                
                Button("Submit") {
                    isRecovering = true // Muestra la pantalla de carga
                    Task {
                        do {
                            try await AuthService.shared.sendPasswordResetEmail(forEmail: email)
                            // Proceso de recuperación exitoso, puedes mostrar un mensaje al usuario
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
        }
        .navigationBarHidden(true)
    }
}

struct RecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        RecoveryView()
    }
}

