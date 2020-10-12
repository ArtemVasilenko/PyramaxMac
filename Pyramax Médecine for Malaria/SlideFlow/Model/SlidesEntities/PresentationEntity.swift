//
//  PresentationEntity.swift
//  MedicalApp
//
//  Created by Artem Karma on 23.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

//class Presentation: NSObject, NSItemProviderWriting {
struct Presentation {
    
    let id: Int?
    let image: String?
    let text: String?
    let imageSource: UIImage?
    let countSlides: Int?
    let pass: String?
    let order_by: Int?
    
    //    internal init(id: Int?, image: String?, text: String?, imageSource: UIImage?, countSlides: Int?, pass: String?, order_by: Int?) {
    //        self.id = id
    //        self.image = image
    //        self.text = text
    //        self.imageSource = imageSource
    //        self.countSlides = countSlides
    //        self.pass = pass
    //        self.order_by = order_by
    //    }
    //
    //    static var writableTypeIdentifiersForItemProvider: [String] {
    //        return [] // something here
    //    }
    //
    //    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
    //        return nil
    //    }
}
