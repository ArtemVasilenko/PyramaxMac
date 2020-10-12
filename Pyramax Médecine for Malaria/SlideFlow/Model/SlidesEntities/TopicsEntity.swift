//
//  TopicsEntity.swift
//  MedicalApp
//
//  Created by Artem Karma on 23.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

struct Topics {
    
    let listTopic: [Topic]
    
    init() {
        self.listTopic = DB().getTopics()
    }
    
    init(idPresent: Int) {
        self.listTopic = DB().getTopicsOnPresent(idPresent)
    }
}
