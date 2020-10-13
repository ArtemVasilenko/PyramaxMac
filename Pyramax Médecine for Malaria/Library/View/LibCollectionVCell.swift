//  LibCollectiVC.swift
//
//
//  Created by Alex Kholodoff on 9/30/19.

import UIKit

class LibCollectionVCell: UICollectionViewCell {
    
    @IBOutlet weak var labelNameTopic: UILabel!
    @IBOutlet weak var tvSlides: UITableView!
    
    @IBOutlet weak var labelNameSlide: UILabel!
    private var listSlides = [Slide]()
    private let cellInd = "CellSlide"
    
    var topic: Topic?
    {
        didSet {
            labelNameTopic.text = "\(self.topic?.name ?? "name topic") \(self.topic?.countSlides ?? 0) slides"
            
            self.listSlides = SlidesInTopic(topic!.id).listSlides
            print("Topic :", topic?.name ?? "name Topic?")
            self.listSlides.forEach{
                print("id slide =", $0.id, ", name slide =", $0.name)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tvSlides.delegate = self
        tvSlides.dataSource = self

        tvSlides.reloadData()
    }
}

extension LibCollectionVCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let count = self.listSlides.count
        print("let count = self.listSlides.count =", count)
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("indexPath.row =", indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellInd)!
        let object = listSlides[indexPath.row].name
        //        print("listSlides[indexPath.row].name =", object)
        cell.textLabel?.text = object
        print("cell.textLabel?.text =", cell.textLabel?.text ?? " empty!!! ")
        //        cell.labelNameSlide.text = object
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "SlideVCSB", bundle: nil)
        let controller: SlideVC = storyboard.instantiateViewController(withIdentifier: "ControllerIdentifier") as! SlideVC
        
        var slide: Slide = listSlides[indexPath.row]
        slide.nameTopic = self.topic?.name
        
        controller.slide = slide
        
        controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        controller.modalPresentationStyle = .overCurrentContext
        let currentController = self.getCurrentViewController()
                
        currentController?.present(controller, animated: true, completion: nil)
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
}
