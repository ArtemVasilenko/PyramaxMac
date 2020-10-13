//
//  VideoCollectionViewCell.swift
//  MedicalApp
//
//  Created by Артем on 8/15/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var countSlidesLabel: UILabel!
    
    var videoItem: Slide? {
        
        didSet {
            videoLabel.text = videoItem?.name
            if let image = videoItem?.icon {
                videoImageView.image = image
            }
            countSlidesLabel.text = videoItem?.description
            videoImageView.layer.masksToBounds = true
            videoImageView.layer.cornerRadius = 10.0
            videoImageView.contentMode = .scaleAspectFill
        }
    }
}
