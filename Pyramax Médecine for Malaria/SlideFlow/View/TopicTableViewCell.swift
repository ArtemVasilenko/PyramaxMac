//
//  TopicTableViewCell.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 09.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class TopicTableViewCell: UITableViewCell {

    lazy var nameTopicLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 5, width: 250, height: 25))
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Name Topic"
        return label
    }()

    lazy var countSlideLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 30, width: 250, height: 25))
//        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 slides"
        label.textColor = .gray
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
        contentView.addSubview(nameTopicLabel)
        contentView.addSubview(countSlideLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func updateConstraints() {
//        let titleInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 8)
//
//        // autoPinEdgesToSuperviewEdges(with: titleInsets, excludingEdge: .bottom)
////        nameTopicLabel.autoPinEdgesToSuperviewEdges(with: titleInsets, excludingEdge: .bottom)
//
//        let descInsets = UIEdgeInsets(top: 0, left: 16, bottom: 4, right: 8)
//        countSlideLabel.autoPinEdgesToSuperviewEdges(with: descInsets, excludingEdge: .top)
//
//        countSlideLabel.autoPinEdge(.top, to: .bottom, of: nameTopicLabel, withOffset: 16)
//        super.updateConstraints()
//    }

}
