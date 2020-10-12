//
//  SlideEntity.swift
//  MedicalApp
//
//  Created by Artem Karma on 23.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

struct Slide {
    
    var id: Int
    var name: String
    var nameTopic: String?
    var html: String?
    var search: String?
    var baseUrl: URL?
    var description: String?
    var icon: UIImage?
    var order: String?
    var sound: Data?
    
    init(id: Int = 0, name: String = "") {
        self.id = id
        self.name = name
    }
    
    // init for preview slide
    init(html: String, id: Int = 0, name: String = "") {
        self.id = id
        self.name = name
        self.html = html
    }
    
    init(id: Int, name: String, nameTopic: String) {
        self.id = id
        self.name = name
        self.nameTopic = nameTopic
    }
    
    // init for save result of searh
    init(id: Int, name: String, nameTopic: String, search: String) {
        self.id = id
        self.name = name
        self.nameTopic = nameTopic
        self.search = search
    }
    
    // init for SlideView after search
    init(id: Int, name: String, nameTopic: String, search: String, html: String, baseUrl: URL) {
        self.id = id
        self.name = name
        self.nameTopic = nameTopic
        self.search = search
        self.html = html
        self.baseUrl = baseUrl
    }
    
    // init for Present
    init(_ id: Int, name: String, description: String, icon: UIImage, nameTopic: String ) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.nameTopic = nameTopic
    }
    
    // init for new Present
    init(_ id: Int, name: String, order: String, sound: Data) {
        self.id = id
        self.name = name
        self.order = order
        self.sound = sound
    }
    
    // slide for Video line from DB: get id, name, description, icon
    init(_ id: Int, name: String, description: String, icon: UIImage) {
           self.id = id
           self.name = name
           self.description = description
           self.icon = icon
    }
    
}
