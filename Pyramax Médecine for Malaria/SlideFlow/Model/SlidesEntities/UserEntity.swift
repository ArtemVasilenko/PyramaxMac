//
//  UserEntity.swift
//  MedicalApp
//
//  Created by Artem Karma on 23.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

struct User: KeyChainService {
    
    //     static var shared: Logos = Logos()

    static var shared: User = User()
    
    var avatar: UIImage = UIImage()
    var name: String = "Robert"
    var lastName: String = "Smith"
    var function: String = "Doctor"
    var organization: String = ""
    var country: String = ""
    var city: String = ""
    var email: String = ""
    var phone: String = ""
    var pass: String = ""
    var token: String = "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6NzQsImVtYWlsIjoibzk4NzQwMDM0N0BnbWFpbC5jb20iLCJjcmVhdGVkX2F0IjoxNTc2MTc4OTc0LCJleHAiOjQ3MzE4NTI1NzR9.1F9YU9hj2zQwWyYyBokp391qGmnCHBKPi3jkp5XBHRI"
    var id: Int = 74

//    init(_ user: User) {
//        self = user
//    }
    
    // on default can be removed
//    init(avatar: UIImage, name: String, lastName: String, function: String, organization: String, country: String, city: String, email: String, phone: String, pass: String, token: String) {
//
//        self.avatar = avatar
//        self.name = name
//        self.lastName = lastName
//        self.function = function
//        self.organization = organization
//        self.country = country
//        self.city = city
//        self.email = email
//        self.phone = phone
//        self.pass = pass
//        self.token = token
//    }
    
    func getPassword(_ email: String) -> String {
        return getPass(email)
    }
    
//    func save() {
//        save(self.email, pass: self.pass)
//    }
}
