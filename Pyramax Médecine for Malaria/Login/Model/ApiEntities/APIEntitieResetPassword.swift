//
//  APIEntitiesResetPassword.swift
//  MedicalApp
//
//  Created by Artem Karma on 16.11.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

struct APIEntitieResetPassword: Decodable {
    let data: StatusForm
    let message: String
    let error: Bool
}

struct StatusForm: Decodable {
    let status: String
}
