//
//  SlideTVCell.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 10.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.

import UIKit

class SlideTVCell: UITableViewCell {
        
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
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 180, height: 120))
        imageView.backgroundColor = .orange
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10.0
        return imageView
    }()
    
    private lazy var nameSlideLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 200, y: 5, width: 270, height: 50))
        label.text = "slide.name"
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 25)

        return label
    }()
    
    private lazy var descriptionSlideLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 200, y: 60, width: 270, height: 75))
        label.text = "slide.description"
        label.textColor = .black
        label.numberOfLines = 0

        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
                
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(icon)
        contentView.addSubview(nameSlideLabel)
        contentView.addSubview(descriptionSlideLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
