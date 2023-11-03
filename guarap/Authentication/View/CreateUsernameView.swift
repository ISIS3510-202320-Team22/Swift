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
    @State private var usernameExistsError = false
    @State private var showAlertRepeat = false
    @ObservedObject var networkManager = NetworkManager.shared
    
    @Binding var showing: Bool
    @State var showNext = false
    
    @AppStorage("creatingProfile") var creatingProfile = true
    
    var body: some View {
        NavigationStack {
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
                
                NavigationLink(destination: CreatePasswordView(showing: $showNext), isActive: $showNext) {
                    Button(action: {
                        Task {
                            if await viewModel.usernameExists(username: viewModel.username) {
                                showAlertRepeat = true
                                hideBannerAfterDelay(2)
                            } else if viewModel.username.count < MIN_USER_CHAR_LIMIT {
                                isShowingAlert = true
                                hideBannerAfterDelay(2)
                            } else {
                                showNext = true // Activate the NavigationLink
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
                //.opacity(0) // Hide the navigation link
                
                
                
                if showAlertRepeat {
                    BannerView(text: "The username you entered is already associated with an account.", color: .yellow)
                }
                
                if isShowingAlert {
                    BannerView(text: "User must have at least \(MIN_USER_CHAR_LIMIT) characters.", color: .red)
                }
                
            }
        }
        .onChange(of: showNext) { result in
            if !creatingProfile {
                showing = result
            }
        }
    }
    func hideBannerAfterDelay(_ seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            showAlertRepeat = false
            isShowingAlert = false
        }
    }
}

//struct CreateUsernameView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateUsernameView(showing: .constant(true))
//    }
//}
