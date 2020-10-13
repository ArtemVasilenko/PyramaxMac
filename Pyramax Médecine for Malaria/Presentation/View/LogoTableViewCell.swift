//
//  LogoTableViewCell.swift
//  MedicalApp
//
//  Created by Артем Василенко on 06.04.2020.
//  Copyright © 2020 iOS Team. All rights reserved.
//

import UIKit

class LogoTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var selectLogoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
}
