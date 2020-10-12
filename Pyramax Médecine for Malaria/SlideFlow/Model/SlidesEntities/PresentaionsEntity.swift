//
//  PresentaionsEntity.swift
//  MedicalApp
//
//  Created by Artem Karma on 23.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

struct Presentations {
    
    let listPresent: [Presentation]
    
    init() {
        self.listPresent = DB().getPresentList()
    }
    
    // make with protocoll
    func presentsReOrder(_ presents: [Presentation]) {
        
        var presentOrderBy = 1
        for present in presents {
            if let presentId = present.id {
                print(presentId, presentOrderBy)
                DB().updateListPresentOnOrder(presentId, order_by: presentOrderBy)
                presentOrderBy += 1
            }
        }
    }
}
