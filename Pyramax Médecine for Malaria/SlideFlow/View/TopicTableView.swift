//
//  TopicTV.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 09.10.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class TopicTV: UITableView, UITableViewDataSource, UITableViewDelegate {
    private var topics: Topics
    private let topicCellIdentifier = "topicCellIdentifier"

//    private var idPresent: Int
    
    init(frame: CGRect, topics: Topics) {
        
        let frameTopic = CGRect(x: 20, y: 75, width: (frame.width - 40) / 3, height: frame.height - 85)
        
//        self.idPresent = idPresent
        self.topics = topics
                
        super.init(frame: frameTopic, style: UITableView.Style.plain)
        
        self.dataSource = self
        self.delegate = self
        
        register(TopicTableViewCell.self, forCellReuseIdentifier: topicCellIdentifier)
        rowHeight = 68
        backgroundColor = .clear
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TopicTV {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.listTopic.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         let cell = self.dequeueReusableCell(withIdentifier: topicCellIdentifier, for: indexPath) as! TopicTableViewCell

        let nameTopic = topics.listTopic[indexPath.row].name
        let countSlides = " \(topics.listTopic[indexPath.row].countSlides ?? 0) slides"

        cell.nameTopicLabel.text = nameTopic
        cell.countSlideLabel.text = countSlides
        
        return cell
     }
    
}

