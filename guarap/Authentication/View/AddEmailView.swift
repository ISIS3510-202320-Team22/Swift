//
//  AddEmailView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import SwiftUI

struct AddEmailView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)

    @State private var isShowingAlert = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Add your email")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            Text("You'll use this email to sign in to your account")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            TextField("Email", text: $viewModel.email)
                .autocapitalization(.none)
                .font(.subheadline)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 24)
                .padding(.top)
                .onChange(of: viewModel.email) { newValue in
                    
                    let allowedSymbols = CharacterSet(charactersIn: "!@#$%^&*()-+{}[]~_=\\/?<>.,:;\"\'`")
                    
                    viewModel.email = newValue.filter { !$0.isWhitespace }
                    
                    viewModel.email = String(viewModel.email.unicodeScalars.filter {
                                CharacterSet.alphanumerics.union(allowedSymbols).contains($0)
                            })
                    
                    
                    if newValue.count > MAX_EMAIL_CHAR_LIMIT {
                        viewModel.email = String(newValue.prefix(MAX_EMAIL_CHAR_LIMIT))
                    }
                }

            NavigationLink(destination: CreateUsernameView(), isActive: $viewModel.isNextButtonTapped) {
                EmptyView()
            }
            .opacity(0) // Hide the navigation link

            Button(action: {
                if viewModel.email.count < MIN_EMAIL_CHAR_LIMIT {
                    isShowingAlert = true
                } else if !viewModel.email.hasSuffix("@uniandes.edu.co") {
                    isShowingAlert = true
                } else {
                    // Llama a la función para verificar si el correo electrónico ya está registrado
                    AuthService.shared.isEmailAlreadyRegistered(email: viewModel.email) { isRegistered, error in
                        if let error = error {
                            print("Error al verificar el correo electrónico: \(error.localizedDescription)")
                            // Tratar el error, por ejemplo, mostrando una alerta al usuario
                        } else {
                            if isRegistered {
                                // El correo electrónico ya está registrado, muestra una alerta al usuario
                                isShowingAlert = true
                            } else {
                                // El correo electrónico no está registrado, puedes activar el NavigationLink
                                viewModel.isNextButtonTapped = true
                            }
                        }
                    }
                }
            }) {
                Text("Next")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 360, height: 44)
                    .background(guarapColor)
                    .cornerRadius(8)
            }
            .padding(.vertical)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Invalid Email"),
                message: Text("Email is not correct and must end with '@uniandes.edu.co'."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}



struct AddEmailView_Previews: PreviewProvider {
    static var previews: some View {
        AddEmailView()
    }
}

