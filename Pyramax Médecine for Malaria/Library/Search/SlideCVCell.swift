//
//  SlideCVCell.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 23.02.2020.
//  Copyright © 2020 iOS Team. All rights reserved.
//

import UIKit

class SlideCVCell: UICollectionViewCell {
    
    var slide: Slide? {
        didSet {
            nameSlideLabel.text = slide?.name
            descriptionSlideLabel.text = slide?.description
            if let image = slide?.icon {
                icon.image = image
            }
        }
    }
        
    private lazy var icon: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 170, height: 100))
        imageView.backgroundColor = .clear
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    private lazy var nameSlideLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 180, y: 0, width: 170, height: 30))
        label.text = "slide.name"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)

        return label
    }()
    
    private lazy var descriptionSlideLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 180, y: 40, width: 170, height: 60))
        label.text = "slide.description"
        label.textColor = .black
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var viewCell: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 100))
        view.addSubview(icon)
        view.addSubview(nameSlideLabel)
        view.addSubview(descriptionSlideLabel)
//        view.backgroundColor = .black
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.addSubview(viewCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
