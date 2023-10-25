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
                    viewModel.isNextButtonTapped = true // Activate the NavigationLink
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

