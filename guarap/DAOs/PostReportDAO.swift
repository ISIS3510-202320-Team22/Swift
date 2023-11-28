//
//  PostReportDAO.swift
//  guarap
//
//  Created by Quiroga Alfaro Nathalia Alexandra on 28/11/23.
//

import Foundation

protocol PostReportDAO {
    func sendPostReport(description: String, id_post: String, id_user_post: String, completion: @escaping (Bool) -> Void)
}
