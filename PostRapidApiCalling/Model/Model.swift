//
//  Model.swift
//  PostRapidApiCalling
//
//  Created by Arpit iOS Dev. on 10/06/24.
//

import Foundation
import UIKit

// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    let quote, author: String
    let category: String
    
}

typealias Welcome = [WelcomeElement]
