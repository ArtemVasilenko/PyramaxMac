//  SearchVCViewController.swift
//  MedicalApp
//
//  Created by Alex Kholodoff on 9/9/19.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UIGestureRecognizerDelegate {
    
    var db = DB()
    let indentifier = "MyCell"
    var slides = [Slide]()
    
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var lastTF: UITextField!
    
    @IBOutlet weak var searchBt: UIButton!
    @IBOutlet weak var reindexBt: UIButton!
    
    @IBOutlet weak var searchCollView: UICollectionView!
    
    override func viewDidLoad() {
        
        
        
        searchTF.delegate = self
        
        searchCollView.dataSource = self
        searchCollView.delegate = self
        
        searchCollView.register(SlideCVCell.self, forCellWithReuseIdentifier: "IdentCell")
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
//        self.colVw.addGestureRecognizer(lpgr)
        self.view.addGestureRecognizer(lpgr)

    }
    
    //MARK: - UILongPressGestureRecognizer Action -
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            //When lognpress is start or running
//            reindexAlert()
        }
        else {
            //When lognpress is finish
            reindexAlert()

        }
    }
    
    @IBAction func btBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func btSearch(_ sender: UIButton) {
        self.searchSlides()
    }
    
    @IBAction func btReindex(_ sender: UIButton) {
        reindexAlert()
    }
    
    func searchSlides() {
        guard let query = searchTF.text, query.count > 0  else { return }
        
        self.slides = []
        
        let arrWordSearch = db.splittingSearch(query)
        let querySql = db.prepareSearch(arrWordSearch)
        
        self.slides = db.searchSlides(querySql)
        print("slides = ", slides)
        
        searchCollView.reloadData()
    }
}

// MARK: - reindex table slides_search
extension SearchVC {
    
    func reindex(from: Int = 0, to: Int = 0) {
        
        DispatchQueue.global(qos: .background).async {
            let dbThread = self.db
            
            DispatchQueue.main.async {
                for i in from...to {
                    dbThread.createDict(i)
                    print("slide \(i) is done to table slides_search")
                }
            }
        }
    }
}

// MARK: - searchCollView
extension SearchVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = searchCollView.dequeueReusableCell(withReuseIdentifier: "IdentCell", for: indexPath) as! SlideCVCell
        cell.backgroundColor = .clear
        
        
        cell.slide = db.getSlideInfo(slides[indexPath.row].id)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("test\(indexPath)")

        
        let storyboard: UIStoryboard = UIStoryboard(name: "SlideVCSB", bundle: nil)
        let controller: SlideVC = storyboard.instantiateViewController(withIdentifier: "ControllerIdentifier") as! SlideVC
        
        controller.slide = slides[indexPath.row]
        
//        controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: - searchTF - on input text
extension SearchVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        self.searchSlides()
        return true
    }
    
    //listen to on edit event
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        searchSlides()
    }
    
    //listen to on end edit event
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        searchSlides()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //        self.searchSlides()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        self.searchSlides()
        return true
    }
    
    //listen to return button event
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // return button will close keyboard
        
        //        searchSlides()
        return true
    }
    
}

// MARK: - Alert for reindex on long click or 3 click?
extension SearchVC {
    
    fileprivate func reindexAlert() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        
        let alert = UIAlertController(title: "Reindex", message: "input from to number of the slides", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "OK", style: .default) { _ in
            let from = Int(alert.textFields![0].text ?? "") ?? 0
            let to = Int(alert.textFields![1].text ?? "") ?? 0
            
            guard to >= from else {
                return
            }
            
            self.reindex(from: from, to: to)
            
            blurVisualEffectView.removeFromSuperview()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            blurVisualEffectView.removeFromSuperview()
        }
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        self.view.addSubview(blurVisualEffectView)
        self.present(alert, animated: true, completion: nil)
    }
    
}
