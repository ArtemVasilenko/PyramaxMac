//
//  ReportAfterSlideViewController.swift
//  MedicalApp
//
//  Created by Nikita Traydakalo on 29.12.2019.
//  Copyright © 2019 iOS Team. All rights reserved.
//

import UIKit

class ReportAfterSlideViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var cell: RightTableViewCell!
    private var gestures = [UITapGestureRecognizer]()
    private var imageId = 0
    private let rightCellIdentifier = "table"
    private var picker: UIImagePickerController? = UIImagePickerController()
    var presentationName = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Answear from Report - PresentName = \(self.presentationName)")
        let navigationBar = self.navigationController?.navigationBar
//        let moneyLabel = UILabel(frame: CGRect(x: 330, y: 0, width: (navigationBar?.frame.width)!/2, height: (navigationBar?.frame.height)!))
        let moneyLabel = UILabel(frame: CGRect(x: (navigationBar?.frame.width)! / 3 + 20, y: 0, width: (navigationBar?.frame.width)!/2, height: (navigationBar?.frame.height)!))
        moneyLabel.text = ReportsWords.shared.reports
        navigationBar?.addSubview(moneyLabel)
        

        
        cell = RightTableViewCell()
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.initFields(RightReport(id: 0, country: "", city: "", countPeople: 0, visitType: 1, comment: "", image01: nil, image02: nil, image03: nil))
        cell.customInitReportAfterSlide()
        cell.visitId = 1
        cell.setVisistType(reportVisitTypeEnglish[0])
        picker?.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(RightTableViewCell.self, forCellReuseIdentifier: rightCellIdentifier)
       
        let singleTapping = [#selector(singleTappingImageOne), #selector(singleTappingImageTwo), #selector(singleTappingImageThree), #selector(singleTappingVisitType)]
        for i in 0..<singleTapping.count {
            gestures.append(UITapGestureRecognizer(target: self, action: singleTapping[i]))
            gestures[i].numberOfTapsRequired = 1
        }
        cell.typeOfEvent.addGestureRecognizer(gestures[3])
        cell.reportButton.addTarget(self, action: #selector(buttonReportPress), for: .touchUpInside)
        cell.laterButton.addTarget(self, action: #selector(buttonLaterPress), for: .touchUpInside)
        cell.images[0].buttonClose.addTarget(self, action: #selector(closeImageOne), for: .touchUpInside)
        cell.images[1].buttonClose.addTarget(self, action: #selector(closeImageTwo), for: .touchUpInside)
        cell.images[2].buttonClose.addTarget(self, action: #selector(closeImageThree), for: .touchUpInside)
    }
    
    func reinitImages(_ count: Int) {
        if count < 3 {
            cell.countImages = count
        } else {
            cell.countImages = 3
        }
        if count < 3 {
            cell.images[count].image = UIImage(named: "Plus")
        }
        if count + 1 < 3 {
            cell.images[count + 1].image = nil
        }
        
        for i in 0..<4 {
            if i  == count - 1 {
                cell.images[i].isCloseButton(true)
            } else {
                if i < cell.images.count {
                    cell.images[i].isCloseButton(false)
                }
            }
        }
        for i in 0..<count + 1 {
            if i < cell.images.count {
                cell.images[i].addGestureRecognizer(gestures[i])
            }
        }
        for i in count + 1..<4 {
            if i < cell.images.count {
                cell.images[i].removeGestureRecognizer(gestures[i])
            }
        }
    }
    
    func exit() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func usageProprePress(_ sender: UIBarButtonItem) {
        exit()
//        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ReportAfterSlideViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView != self.tableView {
            cell.visitId = indexPath.row + 1
            cell.setVisistType(reportVisitTypeEnglish[indexPath.row])
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 1
        } else {
            return reportVisitTypeEnglish.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 750
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.doForArchive(false)
        reinitImages(0)
        return cell
    }
}

extension ReportAfterSlideViewController: UITextViewDelegate {
    
    
    @objc func buttonReportPress(_ sender: UIButton) {
        
        guard Connectivity.isConnectedToInternet() else {
            self.reportAlert(titleAlert: InternetError.shared.sorry, message: InternetError.shared.internetIsNotConected, titleButton: InternetError.shared.ok)
            return
        }
        
        var rep = cell.getReport()
        rep?.presentationName = presentationName
        
        if let report = rep {
            print(report.country, report.city,report.countPeople, report.visitType, report.comment)
        
            guard report.country != "" else {
                self.reportAlert(titleAlert: ReportsWords.shared.error, message: ReportsWords.shared.errorCountry, titleButton: ReportsWords.shared.ok)
                return
            }
            
            guard report.city != "" else {
                self.reportAlert(titleAlert: ReportsWords.shared.error, message: ReportsWords.shared.errorCity, titleButton: ReportsWords.shared.ok)
                return
            }
            
            guard report.countPeople != 0 else {
                self.reportAlert(titleAlert: ReportsWords.shared.error, message: ReportsWords.shared.errorPeopleCount, titleButton: ReportsWords.shared.ok)
                return
            }
            
            guard cell.countImages != 0 else {
                self.reportAlert(titleAlert: ReportsWords.shared.error, message: ReportsWords.shared.errorPhoto, titleButton: ReportsWords.shared.ok)
                return
            }
            
            DB().insertReport(report)
            let id = DB().getLastUpdateId()
            if let index = id {
                DB().updateImageForReport(index, cell.getImages())
                DB().sendReport(index)
            }
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let result = formatter.string(from: date)
            
            var tmpReport = cell.getReport()!
            let api = API()
            tmpReport.presentationName = presentationName
            tmpReport.data = result
            api.sendReport(tmpReport)
            exit()
        }
        
    }
    
    @objc func buttonLaterPress(_ sender: UIButton) {
        print("later")
        var rep = cell.getReport()
        rep?.presentationName = presentationName
        
        if let report = rep {
            print(report.country, report.city,report.countPeople, report.visitType, report.comment)
            DB().insertReport(report)
            let id = DB().getLastUpdateId()
            if let index = id {
                DB().updateImageForReport(index, cell.getImages())
            }
            exit()
        }
    }
    
    @objc func singleTappingImageOne(recognizer: UIGestureRecognizer) {
        imageId = 0
        openGallary()
    }
    
    @objc func singleTappingImageTwo(recognizer: UIGestureRecognizer) {
        imageId = 1
        openGallary()
    }
    
    @objc func singleTappingImageThree(recognizer: UIGestureRecognizer) {
        imageId = 2
        openGallary()
    }
    
    @objc func closeImageOne(sender: UIButton) {
        reinitImages(0)
    }
    
    @objc func closeImageTwo(sender: UIButton) {
         reinitImages(1)
    }
    
    @objc func closeImageThree(sender: UIButton) {
        reinitImages(2)
    }
    
    @objc func singleTappingVisitType(recognizer: UIGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "VisitTypeSB", bundle: nil)
        let controller: VisitTypeViewController = storyboard.instantiateViewController(withIdentifier: "VisitTypeVC") as! VisitTypeViewController
        
        self.present(controller, animated: true, completion: nil)
        controller.TB.delegate = self
    }
}

extension ReportAfterSlideViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openGallary() {
        picker!.allowsEditing = false
        picker!.sourceType = .photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        cell.images[imageId].image = image
        self.reinitImages(imageId + 1)
    }
}


 fileprivate extension RightTableViewCell {
    func customInitReportAfterSlide() {
        country.isLine = true
        city.isLine = true
        laterButton = UIButton()
        reportButton.setTitle(ReportsWords.shared.sent, for: .normal)
        laterButton.setTitleColor(.lightGray, for: .normal)
        laterButton.layer.shadowRadius = 5
        laterButton.layer.cornerRadius = 10
        laterButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        laterButton.layer.borderWidth = 1.0
        laterButton.clipsToBounds = true
        laterButton.backgroundColor = .white
        addSubview(laterButton)
       
        laterButton.translatesAutoresizingMaskIntoConstraints = false
        laterButton.leftAnchor.constraint(equalTo: reportButton.leftAnchor).isActive = true
        laterButton.rightAnchor.constraint(equalTo: reportButton.rightAnchor).isActive = true
        laterButton.topAnchor.constraint(equalTo: reportButton.bottomAnchor, constant: 8).isActive = true
        laterButton.heightAnchor.constraint(equalTo: reportButton.heightAnchor).isActive = true
        
        laterButton.setTitle(ReportsWords.shared.later, for: .normal)
    }
}


extension ReportAfterSlideViewController {
    
    fileprivate func reportAlert(titleAlert: String, message: String, titleButton: String) {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        
        let alert = UIAlertController(title: titleAlert, message: message, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: titleButton, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            blurVisualEffectView.removeFromSuperview()
        }
        
        alert.addAction(submitAction)
        
        self.view.addSubview(blurVisualEffectView)
        self.present(alert, animated: true, completion: nil)
    }
    
}
