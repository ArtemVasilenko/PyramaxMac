//
//  SlideTableVCell.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 10/1/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class SlideTableVCell: UITableViewCell {
    
    var slide = Slide()
    
    @IBOutlet weak var labelNameSlide: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
