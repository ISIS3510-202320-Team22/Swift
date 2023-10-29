//
//  NetworkManager.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 28-10-2023.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    @Published var isOnline = true

    private init() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            self.isOnline = path.status == .satisfied
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
