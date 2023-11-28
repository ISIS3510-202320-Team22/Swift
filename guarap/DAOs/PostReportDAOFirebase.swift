//
//  PostReportDAOFirebase.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 28/11/23.
//

import Foundation
import SwiftUI
import Firebase

class PostReportDAOFirebase: PostReportDAO {
    @AppStorage("username") var username = ""
    
    private init(){}
    
    static var shared: PostReportDAO = PostReportDAOFirebase()
    
    func sendPostReport(description: String, id_post: String, id_user_post: String, completion: @escaping (Bool) -> Void) {
        let firestore = Firestore.firestore()
        let bugCollection = firestore.collection("postReports")
        
        do {
            let postReportRef = bugCollection.document()
            let postReportAttributes: [String: Any] = [
                "description": description,
                "id_post": id_post,
                "id_user_post": id_user_post,
                "id_user_send": username
            ]
            
            postReportRef.setData(postReportAttributes) { error in
                if let error = error {
                    print("Error writing document: \(error)")
                    completion(false)
                } else {
                    print("Post report sent successfully")
                    completion(true)
                }
            }
        }
    }
}
