//
//  CreateUsernameView.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import SwiftUI

struct CreateUsernameView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    
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
            NavigationLink{
                CreatePasswordView()
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

struct CreateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUsernameView()
    }
}
