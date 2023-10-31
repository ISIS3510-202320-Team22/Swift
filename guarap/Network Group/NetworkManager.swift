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
    @Published var isConnectionBad = false

    private init() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            let queue = DispatchQueue.main
            queue.sync {
                self.isOnline = path.status == .satisfied
                self.isConnectionBad = path.isExpensive
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
