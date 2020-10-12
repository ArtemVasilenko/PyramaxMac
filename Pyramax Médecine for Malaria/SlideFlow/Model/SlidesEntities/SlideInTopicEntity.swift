//
//  SlideInTopicEntity.swift
//  MedicalApp
//
//  Created by Artem Karma on 23.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

struct SlidesInTopic {
    
    var listSlides: [Slide]
    
    init(_ idTopic: Int) {
        
        self.listSlides = DB().getNameSlidesInTopic(idTopic)
    }
}
