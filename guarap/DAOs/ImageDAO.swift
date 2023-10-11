//
//  ImageDAO.swift
//  guarap
//
//  Created by Esteban Gonzalez Ruales on 04-10-2023.
//

import Foundation
import SwiftUI

protocol ImageDAO {
    
    static var shared: ImageDAO { get }
    
    func getImageFromUrl(url: String, completion: @escaping (UIImage?) -> Void)
}
