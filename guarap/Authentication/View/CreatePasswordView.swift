//
//  CreateUsernameView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import SwiftUI

struct CreatePasswordView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text ("Create a password")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight (.bold)
                .padding (.top)
            Text("You'll use this password to sign in to your account. Your password should have at least 6 characters.")
                .font (.footnote)
                .foregroundColor (.gray)
                .multilineTextAlignment (.center)
                .padding (.horizontal, 24)
            SecureField("Password", text: $viewModel.password)
                .autocapitalization(.none)
                .font (.subheadline)
                .padding (12)
                .background (Color(.systemGray6))
                .cornerRadius (10)
                .padding (.horizontal, 24)
                .padding (.top)
            NavigationLink{
                CompleteSignUpView()
            } label: {
                Text ("Next" )
                    .font (. subheadline)
                    .fontWeight (.semibold)
                    .foregroundColor(.white)
                    .frame(width: 360,
                           height: 44)
                    .background(Color(.red))
                    .cornerRadius(8)
            }
            .padding (.vertical)
        }
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView()
    }
}
