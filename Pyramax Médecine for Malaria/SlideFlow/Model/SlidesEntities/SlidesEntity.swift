//
//  SlidesEntity.swift
//  MedicalApp
//
//  Created by Artem Karma on 23.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

struct Slides {
    
    var listSlides: [Slide]
    
    // init for Present
    init(idPresent: Int, idTopic: Int) {
        self.listSlides = DB().getListSlidesInTopicOnPresent(idPresent: idPresent, idTopic: idTopic)
    }
    
    // get list slides for Video line from DB: get id, name, description, icon
    init() {
        self.listSlides = DB().getListSlidesForVideoLine()
    }
    
    // init for new Present
    init(_ idPresent: Int) {
        self.listSlides = DB().getListSlidesOnPresent(idPresent)
    }
    
    // getListSlidesForLibrary(_ idTopic: Int)
    // init for Library
    init(idTopic: Int) {
        self.listSlides = DB().getListSlidesForLibrary(idTopic)
    }
}
