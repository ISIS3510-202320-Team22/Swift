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

    var body: some View {
        VStack(spacing: 12) {
            Text ("Welcome to Guarap, \(viewModel.username)!")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight (.bold)
                .padding (.top)
            Text("Click below to complete registration")
                .font (.footnote)
                .foregroundColor (.gray)
                .multilineTextAlignment (.center)
                .padding (.horizontal, 24)
            Button{
                Task{ try await viewModel.createUser()}
            } label: {
                Text ("Complete Sing Up" )
                    .font (. subheadline)
                    .fontWeight (.semibold)
                    .foregroundColor(.white)
                    .frame(width: 360,
                           height: 44)
                    .background(guarapColor)
                    .cornerRadius(8)
            }
            .padding (.vertical)
        }
    }
}

struct CompleteSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSignUpView()
    }
}
