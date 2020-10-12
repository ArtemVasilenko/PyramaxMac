//
//  DocSlideEntity.swift
//  MedicalApp
//
//  Created by Artem Karma on 23.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

struct DocSlide {
    
    var idSlide: Int
    var idDoc: Int
    var nameDoc: String
    
    init(idSlide: Int, idDoc: Int, nameDoc: String) {
        self.idSlide = idSlide
        self.idDoc = idDoc
        self.nameDoc = nameDoc
    }
}
