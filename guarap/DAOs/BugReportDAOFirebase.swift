//
//  BugReportDAOFirebase.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 15-11-2023.
//

import Foundation
import SwiftUI
import Firebase

class BugReportDAOFirebase: BugReportDAO {
    @AppStorage("username") var username = ""
    
    private init(){}
    
    static var shared: BugReportDAO = BugReportDAOFirebase()
    
    func sendBugReport(title: String, description: String, completion: @escaping (Bool) -> Void) {
        let firestore = Firestore.firestore()
        let bugCollection = firestore.collection("bugReports")
        
        do {
            let bugReportRef = bugCollection.document()
            let bugReportAttributes: [String: Any] = [
                "title": title,
                "description": description,
                "username": username
            ]
            
            bugReportRef.setData(bugReportAttributes) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    completion(false)
                } else {
                    print("Bug report sent successfully")
                    completion(true)
                }
            }
        }
    }
}
