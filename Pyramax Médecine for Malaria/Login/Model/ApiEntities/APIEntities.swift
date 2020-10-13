//
//  APIEntities.swift
//  MedicalApp
//
//  Created by Artem Karma on 23.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import Foundation
import UIKit

// MARK: - APIEntities
struct APIEntitie: Codable {
    let str: APIEntities
    let message: String
    let error: String
}

struct APIEntities: Codable {
    let api_token: String?
    let avatar: Data?
    let city: String?
    let country: String?
    let created_at: String
    let email: String
    let function: String?
    let id: Int
    let lastName: String?
    let name: String?
    let organization: String?
    let phone: String?
}
