//
//  PresentationsCollectionViewCell.swift
//  MedicalApp
//
//  Created by Артем on 8/15/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class PresentationsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var presentationsImageView: UIImageView!
    @IBOutlet weak var presentationsLabel: UILabel!
    @IBOutlet weak var labelCountSlides: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    
    var presentItem: Presentation? {
        
        didSet {
            labelCountSlides.text = "\(presentItem?.countSlides ?? 0) slides"
            presentationsLabel.text = presentItem?.text
            presentationsImageView.image = presentItem?.imageSource
            presentationsImageView.layer.masksToBounds = true
            presentationsImageView.layer.cornerRadius = 10.0
            presentationsImageView.contentMode = .scaleAspectFill
        }
    }
}
