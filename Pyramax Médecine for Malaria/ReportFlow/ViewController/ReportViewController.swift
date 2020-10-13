import UIKit

class ReportViewController: UIViewController {
    @IBOutlet weak var okButtonOutlet: UIButton!
    @IBOutlet weak var leftTB: UITableView!
    @IBOutlet weak var rightTB: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    private var alertView: AlertView!
    private var picker: UIImagePickerController? = UIImagePickerController()
    private var imageId = 0
    
    private let rightCellIdentifier = "rightTB"
    private let leftCellIdentifier = "leftTB"
    private var report = Report()
    
    private var cell: RightTableViewCell!
    private var gestures = [UITapGestureRecognizer]()
    
    
    override func viewDidLoad() {
        self.okButtonOutlet.isHidden = true
//        let storyboard: UIStoryboard = UIStoryboard(name: "ReportSB", bundle: nil)
//        let controller: ReportAfterSlideViewController = storyboard.instantiateViewController(withIdentifier: "ReportAfterSlide") as! ReportAfterSlideViewController
//        let navController = UINavigationController(rootViewController: controller)
//        self.present(navController, animated:true, completion: nil)

//        let api = API()
//        api.sendReport(UIImage(named: "Plus")!)
//        print("User---------------------")
//       
//        print(User.shared.token)
//        print(User.shared.id)
//        let apiTmp = API()
//        apiTmp.registerUser("name1", "lastName1", "country1", "city1", "123456789", "function1", "organization1", "test12@mail.com", "12345678", "12345678", cell.getImages()[0]!)
        
        
        
        segment.selectedSegmentIndex = 0
        customInit()
        picker?.delegate = self
        
        rightTB.delegate = self
        rightTB.dataSource = self
        self.rightTB.register(RightTableViewCell.self, forCellReuseIdentifier: rightCellIdentifier)
        
        leftTB.delegate = self
        leftTB.dataSource = self
        self.leftTB.register(UITableViewCell.self, forCellReuseIdentifier: leftCellIdentifier)
        
        segment.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        cell = RightTableViewCell()
        let singleTapping = [#selector(singleTappingImageOne), #selector(singleTappingImageTwo), #selector(singleTappingImageThree), #selector(singleTappingVisitType)]
        for i in 0..<4 {
            gestures.append(UITapGestureRecognizer(target: self, action: singleTapping[i]))
            gestures[i].numberOfTapsRequired = 1
        }
        
        if Connectivity.isConnectedToInternet() == false {
            cell.reportButton.isEnabled = false
        }
        
        cell.reportButton.addTarget(self, action: #selector(buttonReportPress), for: .touchUpInside)
        cell.country.addTarget(self, action: #selector(textFieldsDidEndEditing), for: .editingDidEnd)
        cell.city.addTarget(self, action: #selector(textFieldsDidEndEditing), for: .editingDidEnd)
        cell.numberOfPeople.addTarget(self, action: #selector(textFieldsDidEndEditing), for: .editingDidEnd)
        cell.comment.delegate = self
        cell.images[0].buttonClose.addTarget(self, action: #selector(closeImageOne), for: .touchUpInside)
        cell.images[1].buttonClose.addTarget(self, action: #selector(closeImageTwo), for: .touchUpInside)
        cell.images[2].buttonClose.addTarget(self, action: #selector(closeImageThree), for: .touchUpInside)
        
        reinitImages(cell.countImages)
        
        if report.count > 0 {
            report.selectedIndex = 0
            let indexPath = IndexPath(row: 0, section: 0)
            leftTB.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            self.tableView(leftTB, didSelectRowAt: indexPath)
        }
       
        alertView.create(report.count)
    }
    
    @IBAction func okButtonOutlet(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
    
    func customInit() {
        self.view.backgroundColor = .white
        self.leftTB.backgroundColor = .white
        self.rightTB.backgroundColor = .white
        
        alertView = AlertView()
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        alertView.topAnchor.constraint(equalTo: view.topAnchor, constant: (self.navigationController?.navigationBar.frame.size.height ?? CGFloat(10)) + CGFloat(25)).isActive = true
        alertView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        //alertView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        leftTB.translatesAutoresizingMaskIntoConstraints = false
        leftTB.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        leftTB.rightAnchor.constraint(equalTo: rightTB.leftAnchor).isActive = true
        leftTB.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        leftTB.topAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 8).isActive = true
        leftTB.widthAnchor.constraint(equalToConstant: 200).isActive = true

        rightTB.translatesAutoresizingMaskIntoConstraints = false
        rightTB.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        rightTB.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        rightTB.topAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 8).isActive = true
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == leftTB {
            report.selectedIndex = report.leftReports[indexPath.row].id
            report.rightReport?.presentationName = report.leftReports[indexPath.row].name
            report.rightReport?.data = report.leftReports[indexPath.row].meetDay
            rightTB.reloadData()
        } else if tableView != rightTB {
            cell.visitId = indexPath.row + 1
            cell.setVisistType(reportVisitTypeEnglish[indexPath.row])
            dismiss(animated: true, completion: nil)
            report.updateReport(cell.getReport())
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == rightTB {
            if report.count > 0 {
                return 1
            }
            return 0
        } else if tableView == leftTB {
            return report.count
        } else {
            return reportVisitTypeEnglish.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == rightTB {
            return 700
        } else if tableView == leftTB {
            return 80
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == rightTB {
            cell.id = report.selectedIndex
            cell.initFields(report.rightReport!)
            cell.setImages()
            if segment.selectedSegmentIndex == 0 {
                cell.typeOfEvent.addGestureRecognizer(gestures[3])
                cell.doForArchive(false)
                reinitImages(cell.countImages)
            } else {
                for i in 0..<cell.images.count {
                    cell.images[i].removeGestureRecognizer(gestures[i])
                }
                cell.typeOfEvent.removeGestureRecognizer(gestures[3])
                cell.doForArchive(true)
            }
            return cell
        } else {
            let cell = leftTB.dequeueReusableCell(withIdentifier: leftCellIdentifier, for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel!.text = "\(report.leftReports[indexPath.row].name)\n\(report.leftReports[indexPath.row].meetDay)"
            return cell
        }
    }
}

extension ReportViewController: UITextViewDelegate {
    
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
        DB().updateImageForReport(self.report.rightReport!.id, self.cell.getImages())
    }
    
    @objc func closeImageTwo(sender: UIButton) {
         reinitImages(1)
         DB().updateImageForReport(self.report.rightReport!.id, self.cell.getImages())
    }
    
    @objc func closeImageThree(sender: UIButton) {
        reinitImages(2)
        DB().updateImageForReport(self.report.rightReport!.id, self.cell.getImages())
    }
    
    @objc func singleTappingVisitType(recognizer: UIGestureRecognizer) {
        let storyboard: UIStoryboard = UIStoryboard(name: "VisitTypeSB", bundle: nil)
        let controller: VisitTypeViewController = storyboard.instantiateViewController(withIdentifier: "VisitTypeVC") as! VisitTypeViewController
        
        self.present(controller, animated: true, completion: nil)
        controller.TB.delegate = self
    }
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            report.isArchive = false
            leftTB.reloadData()
            rightTB.reloadData()
        } else {
           report.isArchive = true
            leftTB.reloadData()
            rightTB.reloadData()
        }
        if report.count > 0 {
            report.selectedIndex = 0
            let indexPath = IndexPath(row: 0, section: 0)
            leftTB.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
            self.tableView(leftTB, didSelectRowAt: indexPath)
        }
    }
    
    @objc func textFieldsDidEndEditing(_ sender: Any) {
        report.updateReport(cell.getReport())
    }
    
    
    
    //MARK: - UPDATE BADGE IN TABBAR ICON
        
    @objc func buttonReportPress(_ sender: UIButton) {
        guard Connectivity.isConnectedToInternet() else {
            self.reportAlert(titleAlert: InternetError.shared.sorry, message: InternetError.shared.internetIsNotConected, titleButton: InternetError.shared.ok)
            return
        }
        
        guard cell.country.text != "" else {
            self.reportAlert(titleAlert: ReportsWords.shared.error, message: ReportsWords.shared.errorCountry, titleButton: ReportsWords.shared.ok)
            return
        }
        
        guard cell.city.text != "" else {
            self.reportAlert(titleAlert: ReportsWords.shared.error, message: ReportsWords.shared.errorCity, titleButton: ReportsWords.shared.ok)
            return
        }
        
        guard cell.numberOfPeople.text != "" && cell.numberOfPeople.text != "0" else {
            self.reportAlert(titleAlert: ReportsWords.shared.error, message: ReportsWords.shared.errorPeopleCount, titleButton: ReportsWords.shared.ok)
            return
        }
        
        guard cell.countImages != 0 else {
            self.reportAlert(titleAlert: ReportsWords.shared.error, message: ReportsWords.shared.errorPhoto, titleButton: ReportsWords.shared.ok)
            return
        }
        
        report.sendReport(cell.getReport())
        
        var tmpReport = cell.getReport()!
        let api = API()
        tmpReport.presentationName = report.rightReport?.presentationName
        tmpReport.data = report.rightReport?.data
        api.sendReport(tmpReport)
        
        segmentedControlValueChanged(segment: segment)
        rightTB.reloadData()
        leftTB.reloadData()
        if report.count < 6 {
            alertView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        guard DB().getListReports(false).count != 0 else {
            self.tabBarItem.badgeValue = nil
            return
        }
        
        alertView.create(DB().getListReports(false).count)
        self.tabBarItem.badgeValue = String(DB().getListReports(false).count)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        report.updateReport(cell.getReport())
    }
}

extension ReportViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        DB().updateImageForReport(self.report.rightReport!.id, self.cell.getImages())
    }
}

class RightTableViewCell : UITableViewCell {
    private var labels = [UILabel]()
    var country = TextFieldLine()
    var city = TextFieldLine()
    var numberOfPeople = TextFieldLine()
    var typeOfEvent = ButtonLine()
    var comment = UITextView()
    var images = [CustomImageView]()
    var reportButton = UIButton()
    var laterButton: UIButton!
    var id = 1
    var visitId = 0
    var countImages = 0
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customInit()
        country.isLine = false
        city.isLine = false
        
        numberOfPeople.delegate = self
        country.delegate = self
        city.delegate = self
    }
    
    func getReport() -> RightReport? {
        //print(self.country.text, self.city.text, self.numberOfPeople.text, comment.text)
        if let country = self.country.text,
            let city = self.city.text,
            let countPeople = Int(self.numberOfPeople.text ?? "0"),
            let comment = comment.text {
            let img = getImages()
            
            return RightReport(id: id, country:  country, city: city, countPeople: countPeople, visitType: visitId, comment: comment,image01: img[0], image02: img[1], image03:  img[2])
        }
        return nil
    }
    
    func initFields(_ rightReport: RightReport) {
        self.city.text = rightReport.city
        self.country.text = rightReport.country
        self.numberOfPeople.text = String(rightReport.countPeople)
        self.typeOfEvent.setTitle(reportVisitTypeEnglish[rightReport.visitType - 1], for: .normal)
        visitId = rightReport.visitType
        comment.text = rightReport.comment
    }
    
    func getImages() -> [UIImage?] {
        var images = [UIImage?]()
        for i in 0..<countImages {
            images.append(self.images[i].image )
        }
        for _ in countImages..<3 {
            images.append(nil)
        }
        return images
    }
    
    func doForArchive(_ isArchive: Bool) {
        if isArchive {
            for i in 0..<images.count {
                images[i].isCloseButton(false)
            }
            numberOfPeople.isLine = false
            typeOfEvent.isLine = false
            country.isUserInteractionEnabled = false
            city.isUserInteractionEnabled = false
            numberOfPeople.isUserInteractionEnabled = false
            typeOfEvent.isUserInteractionEnabled = false
            comment.isUserInteractionEnabled = false
            reportButton.isEnabled = false
            reportButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            reportButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0), for: .normal)
        } else {
            numberOfPeople.isLine = true
            typeOfEvent.isLine = true
            country.isUserInteractionEnabled = true
            city.isUserInteractionEnabled = true
            numberOfPeople.isUserInteractionEnabled = true
            typeOfEvent.isUserInteractionEnabled = true
            comment.isUserInteractionEnabled = true
            reportButton.isEnabled = true
            reportButton.backgroundColor = .orange
            reportButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func setVisistType(_ text: String) {
        typeOfEvent.setTitle(text, for: .normal)
    }
    
    func setImages() {
        let tmpImages = DB().getImagesForReport(id)
        var count = 0
        for i in 0..<3 {
            if i < tmpImages.count {
                self.images[i].image = tmpImages[i] ?? UIImage()
                count += 1
            } else {
                self.images[i].image = nil
            }
        }
        countImages = count
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RightTableViewCell {
    
    private func getAnchorForImage() -> [Anchor] {
        let imageAnchors = [
            Anchor(comment.bottomAnchor, leftAnchor, nil),
            Anchor(comment.bottomAnchor, images[0].rightAnchor, nil, images[0].widthAnchor),
            Anchor(comment.bottomAnchor, images[1].rightAnchor, rightAnchor, images[1].widthAnchor)
        ]
        return imageAnchors
    }
    
    private func getAnchorForText() -> [Anchor] {
        let textAnchors = [
            Anchor(labels[namesId.country.rawValue].bottomAnchor, leftAnchor, nil),
            Anchor(labels[namesId.country.rawValue].bottomAnchor, country.rightAnchor, rightAnchor, country.widthAnchor),
            Anchor(labels[namesId.numberOfPeople.rawValue].bottomAnchor, leftAnchor, nil),
            Anchor(labels[namesId.typeOfEvent.rawValue].bottomAnchor, numberOfPeople.rightAnchor, rightAnchor, numberOfPeople.widthAnchor),
            Anchor(labels[namesId.comment.rawValue].bottomAnchor, leftAnchor, rightAnchor)
        ]
        return textAnchors
    }
    
    private func getAnchorForLabels() -> [Anchor] {
        let labelAnchors = [
            Anchor(topAnchor, leftAnchor, nil),
            Anchor(topAnchor, labels[namesId.country.rawValue].rightAnchor, rightAnchor, labels[namesId.country.rawValue].widthAnchor),
            Anchor(country.bottomAnchor, leftAnchor, nil),
            Anchor(country.bottomAnchor, labels[namesId.country.rawValue].rightAnchor,  rightAnchor, labels[namesId.country.rawValue].widthAnchor),
            Anchor(numberOfPeople.bottomAnchor, leftAnchor, rightAnchor)
        ]
        return labelAnchors
    }
    
    private func customInit() {
        for i in 0...namesId.comment.rawValue {
            labels.append(UILabel())
            labels[i].translatesAutoresizingMaskIntoConstraints = false
            labels[i].text = names[i]
            labels[i].textColor = .lightGray
            addSubview(labels[i])
        }
        
        for i in 0..<3 {
            images.append(CustomImageView(frame: CGRect(x: 10, y: 10, width: 10, height: 10)))
            addSubview(images[i])
            images[i].backgroundColor = .white
        }
        
        let imageAnchors = getAnchorForImage()
        let labelAnchors = getAnchorForLabels()
        let textAnchors = getAnchorForText()
        let textFields = [country, city, numberOfPeople]
        
        for i in 0...namesId.numberOfPeople.rawValue {
            labels[i].topAnchor.constraint(equalTo: labelAnchors[i].top, constant: 8).isActive = true
            labels[i].leftAnchor.constraint(equalTo: labelAnchors[i].left, constant: 8).isActive = true
            if let tmp = labelAnchors[i].right { labels[i].rightAnchor.constraint(equalTo: tmp, constant: -8).isActive = true }
            if let tmp = labelAnchors[i].width { labels[i].widthAnchor.constraint(equalTo: tmp).isActive = true }
            
//            textFields[i].text = names[i]
            addSubview(textFields[i])
            textFields[i].translatesAutoresizingMaskIntoConstraints = false
            textFields[i].topAnchor.constraint(equalTo: textAnchors[i].top, constant: 8).isActive = true
            textFields[i].leftAnchor.constraint(equalTo: textAnchors[i].left, constant: 8).isActive = true
            if let tmp = textAnchors[i].right { textFields[i].rightAnchor.constraint(equalTo: tmp, constant: -8).isActive = true }
            if let tmp = textAnchors[i].width { textFields[i].widthAnchor.constraint(equalTo: tmp).isActive = true }
        }
        labels[3].topAnchor.constraint(equalTo: labelAnchors[3].top, constant: 8).isActive = true
        labels[3].leftAnchor.constraint(equalTo: labelAnchors[3].left, constant: 8).isActive = true
        labels[3].rightAnchor.constraint(equalTo: labelAnchors[3].right!, constant: -8).isActive = true
        labels[3].widthAnchor.constraint(equalTo: labelAnchors[3].width!).isActive = true
        
        addSubview(typeOfEvent)
        typeOfEvent.setTitleColor(.black, for: .normal)
        typeOfEvent.contentHorizontalAlignment = .left
        typeOfEvent.translatesAutoresizingMaskIntoConstraints = false
        typeOfEvent.topAnchor.constraint(equalTo: textAnchors[3].top, constant: 8).isActive = true
        typeOfEvent.leftAnchor.constraint(equalTo: textAnchors[3].left, constant: 8).isActive = true
        typeOfEvent.rightAnchor.constraint(equalTo: textAnchors[3].right!, constant: -8).isActive = true
        typeOfEvent.widthAnchor.constraint(equalTo: textAnchors[3].width!).isActive = true
        
        labels[2].heightAnchor.constraint(equalTo: typeOfEvent.heightAnchor).isActive = true
        labels[4].topAnchor.constraint(equalTo: labelAnchors[4].top, constant: 8).isActive = true
        labels[4].leftAnchor.constraint(equalTo: labelAnchors[4].left, constant: 8).isActive = true
        labels[4].rightAnchor.constraint(equalTo: labelAnchors[4].right!, constant: -8).isActive = true
        
        addSubview(comment)
        comment.font = UIFont(name: textFields[2].font!.fontName, size: textFields[2].font!.pointSize)
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.topAnchor.constraint(equalTo: textAnchors[namesId.comment.rawValue].top , constant: 8).isActive = true
        comment.leftAnchor.constraint(equalTo: textAnchors[namesId.comment.rawValue].left, constant: 8).isActive = true
        comment.rightAnchor.constraint(equalTo: textAnchors[namesId.comment.rawValue].right!, constant: -8).isActive = true
        comment.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        for i in 0..<3 {
            images[i].isUserInteractionEnabled = true
            images[i].translatesAutoresizingMaskIntoConstraints = false
            images[i].topAnchor.constraint(equalTo: imageAnchors[i].top, constant: 8).isActive = true
            images[i].leftAnchor.constraint(equalTo: imageAnchors[i].left, constant: 8).isActive = true
            if let tmp = imageAnchors[i].right { images[i].rightAnchor.constraint(equalTo: tmp, constant: -8).isActive = true }
            if let tmp = imageAnchors[i].width { images[i].widthAnchor.constraint(equalTo: tmp).isActive = true }
            
            images[i].heightAnchor.constraint(equalTo: images[i].widthAnchor).isActive = true
        }
        
        
        addSubview(reportButton)
        reportButton.backgroundColor = .orange
        reportButton.setTitle("Report", for: .normal)
        reportButton.layer.cornerRadius = 10
        reportButton.clipsToBounds = true
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.topAnchor.constraint(equalTo: images[0].bottomAnchor, constant: 8).isActive = true
        reportButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        reportButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        reportButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}

extension RightTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        switch textField {
        case numberOfPeople:
            guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
        case country:
            if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }
        case city:
            if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                return false
            }
        default:()
        }
        return true
    }
}

class CustomImageView: UIView {
    private var imageView = UIImageView()
    var buttonClose = UIButton()
    var image: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.layer.cornerRadius = 10
        self.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        imageView.layer.borderWidth = 1.0

        
       
        buttonClose.setTitle("×", for: .normal)
        buttonClose.titleLabel?.font = UIFont(name: (buttonClose.titleLabel?.font.fontName)!, size: 30)
        buttonClose.setTitleColor(.orange, for: .normal)
        buttonClose.backgroundColor = .white
        buttonClose.layer.shadowColor = UIColor.black.cgColor
        buttonClose.layer.shadowOpacity = 10
        buttonClose.layer.shadowOffset = .zero
        buttonClose.layer.shadowRadius = 5
        buttonClose.layer.cornerRadius = 15
        buttonClose.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03).cgColor
        buttonClose.layer.borderWidth = 1.0
        buttonClose.clipsToBounds = true
        
        addSubview(imageView)
        addSubview(buttonClose)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        buttonClose.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonClose.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonClose.centerYAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        buttonClose.centerXAnchor.constraint(equalTo: imageView.rightAnchor).isActive = true
    }
    
    func isCloseButton(_ isClose: Bool) {
        if imageView.image == nil {
            imageView.layer.borderWidth = 0
        } else {
            imageView.layer.borderWidth = 1.0
        }
        if isClose {
            buttonClose.isUserInteractionEnabled = true
            buttonClose.backgroundColor = .white
            buttonClose.setTitle("×", for: .normal)
            buttonClose.layer.shadowRadius = 10
            buttonClose.layer.borderWidth = 1.0
        } else {
            buttonClose.isUserInteractionEnabled = false
            buttonClose.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            buttonClose.setTitle("", for: .normal)
            buttonClose.layer.shadowRadius = 0
            buttonClose.layer.borderWidth = 0
        }
    }
    
    func getImageView() -> UIImageView {
        return imageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AlertView: UIView {
    private var alertLabel = UILabel()
    private var countReportsLabel = UILabel()
    private var heightAnchorLabel: NSLayoutConstraint!
    
    init() {
        super.init(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        addSubview(alertLabel)
        addSubview(countReportsLabel)
        
        alertLabel.numberOfLines = 0
        alertLabel.translatesAutoresizingMaskIntoConstraints = false
        alertLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        alertLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        alertLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        alertLabel.rightAnchor.constraint(equalTo: countReportsLabel.leftAnchor, constant: -8).isActive = true
        heightAnchorLabel = alertLabel.heightAnchor.constraint(equalToConstant: 0)
        heightAnchorLabel.isActive = true
        
        countReportsLabel.textAlignment = .center
        countReportsLabel.translatesAutoresizingMaskIntoConstraints = false
        countReportsLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        countReportsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        countReportsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        countReportsLabel.widthAnchor.constraint(equalTo: countReportsLabel.heightAnchor).isActive = true
    }
    
    func create(_ countReports: Int) {
        switch countReports {
        case 6..<9:
            backgroundColor = .orange
            alertLabel.textColor = .black
            countReportsLabel.textColor = .black
            alertLabel.text = "Attention! You are approaching the maximum number of pending tasks. After reaching 10, access to presentations will be blocked."
            countReportsLabel.text = "\(countReports)/10"
            heightAnchorLabel.constant = 60
        case 9...:
            backgroundColor = .red
            alertLabel.textColor = .white
            countReportsLabel.textColor = .white
            alertLabel.text = "Attention! Access to viewing presentations is blocked. You need to fill out reports to continue working with the system."
            countReportsLabel.text = "\(countReports)/10"
            heightAnchorLabel.constant = 60
        default:
            backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
            alertLabel.text = ""
            countReportsLabel.text = ""
            heightAnchorLabel.constant = 0
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextFieldLine: UITextField{
    let lineView = UIView()
    var isLine: Bool {
        willSet {
            if newValue {
                lineView.backgroundColor = .lightGray
            } else {
                lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            }
        }
    }
    
    init() {
        isLine = true
        super.init(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        lineView.backgroundColor = .lightGray
        self.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TextViewLine: UITextView {
    init() {
        super.init(frame: CGRect(x: 10, y: 10, width: 10, height: 10), textContainer: NSTextContainer(size: CGSize(width: 1000, height: 1000)))
        let view = UIView()
        view.backgroundColor = .lightGray
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}

class ButtonLine: UIButton {
    private let lineView = UIView()
    private let label = UILabel()
    var isLine: Bool {
        willSet {
            if newValue {
                lineView.backgroundColor = .lightGray
                label.text = ">"
            } else {
                lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                label.text = ""
            }
        }
    }
    
    init() {
        isLine = true
        super.init(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
        lineView.backgroundColor = .lightGray
        self.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        label.text = ">"
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: lineView.topAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ReportViewController {
    
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
