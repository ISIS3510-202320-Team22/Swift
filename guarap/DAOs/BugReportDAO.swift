//
//  BugReportDAO.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 15-11-2023.
//

import Foundation

protocol BugReportDAO {
    func sendBugReport(title: String, description: String, completion: @escaping (Bool) -> Void)
}
