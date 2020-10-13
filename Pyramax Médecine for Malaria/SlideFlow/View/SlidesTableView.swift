//
//  SlidesTV.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 10.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class SlidesTV: UITableView {
    
    private let slideCellIdentifier = "slideCellIdentifier"

    init(frame: CGRect) {
        
        let frameSlide = CGRect(x: (frame.width - 40) / 3 + 30, y: 75, width: (frame.width - 40) * 2 / 3 - 10, height: frame.height - 85)
        
        super.init(frame: frameSlide, style: UITableView.Style.plain)

        register(SlideTVCell.self, forCellReuseIdentifier: "slideCellIdentifier")
        rowHeight = 136
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
