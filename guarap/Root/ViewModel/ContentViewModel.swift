//
//  ContentViewModel.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 10/10/23.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth
import SwiftUI

class ContentViewModel: ObservableObject {
    
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        service.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)

    }
}
