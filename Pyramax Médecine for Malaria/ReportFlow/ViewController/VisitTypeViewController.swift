//
//  VisitTypeViewController.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 22.12.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class VisitTypeViewController: UIViewController {
    @IBOutlet weak var TB: UITableView!
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TB.dataSource = self
    }

}

extension VisitTypeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = reportVisitTypeEnglish[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reportVisitTypeEnglish.count
    }
}
