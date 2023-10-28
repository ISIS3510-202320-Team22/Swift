//
//  CreateUsernameView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import SwiftUI

struct CreateUsernameView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    let guarapColor = Color(red: 0.6705, green: 0.0, blue: 0.2431)
    @State private var isShowingAlert = false

    
    var body: some View {
        VStack(spacing: 12) {
            Text ("Create username")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight (.bold)
                .padding (.top)
            Text("You'll use this username to sign in to your account")
                .font (.footnote)
                .foregroundColor (.gray)
                .multilineTextAlignment (.center)
                .padding (.horizontal, 24)
            TextField("Username", text: $viewModel.username)
                .autocapitalization(.none)
                .font (.subheadline)
                .padding (12)
                .background (Color(.systemGray6))
                .cornerRadius (10)
                .padding (.horizontal, 24)
                .padding (.top)
                .onChange(of: viewModel.username) { newValue in
                    
                    let allowedSymbols = CharacterSet(charactersIn: "!@#$%^&*()-+{}[]~_=\\/?<>.,:;\"\'`")
                    
                    viewModel.username = newValue.filter { !$0.isWhitespace }
                    
                    viewModel.username = String(viewModel.username.unicodeScalars.filter {
                                CharacterSet.alphanumerics.union(allowedSymbols).contains($0)
                            })
                    
                    if newValue.count > MAX_USER_CHAR_LIMIT {
                        viewModel.username = String(newValue.prefix(MAX_USER_CHAR_LIMIT))
                    }
                }

            NavigationLink(destination: CreatePasswordView(), isActive: $viewModel.isNextButtonTapped1) {
                EmptyView()
            }
            .opacity(0) // Hide the navigation link

            Button(action: {
                if viewModel.username.count < MIN_USER_CHAR_LIMIT {
                    isShowingAlert = true
                } else {
                    viewModel.isNextButtonTapped1 = true // Activate the NavigationLink
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
                title: Text("Invalid User"),
                message: Text("User must have at least \(MIN_USER_CHAR_LIMIT) characters."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct CreateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUsernameView()
    }
}
