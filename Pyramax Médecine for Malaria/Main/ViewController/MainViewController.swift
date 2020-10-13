import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var presentationsCollectionView: UICollectionView!
    @IBOutlet weak var videoCollectionView: UICollectionView!
    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var exitButtonOutlet: UIButton!
    
    private var listPresent = [Presentation]()
    private var listSlides = [Slide]()
    
    var slideValues = SlideValues()
    var slideNumber: Int!
    
    let presentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func addPresentButton(hidden: Bool) {
        self.view.addSubview(presentButton)
        guard let tabletImage = UIImage(named: "tablet") else { return }
        
        self.presentButton.isHidden = hidden
        self.presentButton.addTarget(self, action: #selector(backPresent), for: .touchUpInside)
        self.presentButton.setBackgroundImage(tabletImage, for: .normal)
        self.presentButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.presentButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        
        self.presentButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.presentButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func backPresent() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.presentStart.rawValue, bundle: nil)
        let controller: SlideViewController = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.slideVC.rawValue) as! SlideViewController
        controller.modalPresentationStyle = .fullScreen
        
        controller.slideValues = self.slideValues
        controller.slideNumber = self.slideNumber
       
        
        if slideNumber == 0 {
            controller.uploadPreviewSlide()
        }
        
//        self.present(controller, animated: true, completion: nil)
        
        self.present(controller, animated: true) {
            controller.upperProgress.progress = self.slideValues.progress
            controller.downProgress.progress = self.slideValues.progress
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.exitButtonOutlet.layer.cornerRadius = 10.0
        self.userAvatar.layer.masksToBounds = true
        self.userAvatar.layer.cornerRadius = 10.0
        self.userAvatar.contentMode = .scaleAspectFill
        self.userAvatar.image = User.shared.avatar
        
        self.welcomeTextLabel.text = "\(ReportsWords.shared.hello), \(User.shared.name)!"
        
        self.addPresentButton(hidden: true)
        
        self.listSlides = Slides().listSlides
        self.listPresent = Presentations().listPresent
        
        self.presentationsCollectionView.dragInteractionEnabled = true
        self.presentationsCollectionView.dragDelegate = self
        self.presentationsCollectionView.dropDelegate = self
    }
    
    
    @IBAction func searchActionButton(_ sender: UIButton) {
    }
    @IBAction func userInfoActionButton(_ sender: UIButton) {
    }
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.closeAppAlert()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate func pushPresentationStart(_ presentation: Presentation) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.presentStart.rawValue, bundle: nil)
        
        let controller: PresentationStartVC = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.presentStartVC.rawValue) as! PresentationStartVC
        
        controller.presentation = presentation
        controller.modalPresentationStyle = .fullScreen
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case presentationsCollectionView:
            let presentation = listPresent[indexPath.row]
            print("Choose Presentation ID = \(presentation.id!)")
            
            guard DB().getListReports(false).count <= 9 else {
                self.feelReportsAlert()
                return
            }
            if presentation.pass != "nil" {
                self.passwordAlert(presentation)
            } else {
                self.pushPresentationStart(presentation)
            }
            
        case videoCollectionView:
            
            let storyboard: UIStoryboard = UIStoryboard(name: "SlideVCSB", bundle: nil)
            let controller: SlideVC = storyboard.instantiateViewController(withIdentifier: "ControllerIdentifier") as! SlideVC
            
            let slide = self.listSlides[indexPath.row]
            controller.slide = slide
            
            controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            controller.modalPresentationStyle = .fullScreen

            self.present(controller, animated: true, completion: nil)
            
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case presentationsCollectionView:
            return listPresent.count
        case videoCollectionView:
            return listSlides.count
        default: break
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case presentationsCollectionView:
            
            let itemCell = presentationsCollectionView.dequeueReusableCell(withReuseIdentifier: "PresentCell", for: indexPath) as? PresentationsCollectionViewCell
            itemCell?.presentItem = listPresent[indexPath.row]
            
            
            let presentation = listPresent[indexPath.row]
            
            if presentation.pass != "nil" {
                itemCell?.lockImageView.isHidden = false
            } else {
                itemCell?.lockImageView.isHidden = true
            }
            
            
            return itemCell ?? UICollectionViewCell()
            
        case videoCollectionView:
            
            let videoItemCell = videoCollectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as? VideoCollectionViewCell
            
            videoItemCell?.videoItem = listSlides[indexPath.row]
            return videoItemCell ?? UICollectionViewCell()
            
        default: break
        }
        return UICollectionViewCell()
    }
}

// MARK: - reorder present line
extension MainViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let presentationName = listPresent[indexPath.row].text
        let presentationProvider = NSItemProvider(object: presentationName! as NSString)
        let dragPresent = UIDragItem(itemProvider: presentationProvider)
        dragPresent.localObject = presentationName
        
        print("Starting name present: \(presentationName ?? "presentationName")")
        
        return [dragPresent]
    }
}

extension MainViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item:  row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath {
            
            collectionView.performBatchUpdates({
                let presentRemove = self.listPresent.remove(at: sourceIndexPath.item)
                
                self.listPresent.insert(presentRemove, at: destinationIndexPath.item)
                Presentations().presentsReOrder(self.listPresent)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
}

// MARK: - alerts
extension MainViewController {
    fileprivate func closeAppAlert() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        
        let alert = UIAlertController(title: CloseAppAlert.shared.quit, message: CloseAppAlert.shared.realeLeaveApp, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: CloseAppAlert.shared.yes, style: .default) { _ in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let controller: StartViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! StartViewController
            controller.modalPresentationStyle = .fullScreen
            
            self.present(controller, animated: true, completion: nil)
            
            blurVisualEffectView.removeFromSuperview()
        }
        
        let cancelAction = UIAlertAction(title: CloseAppAlert.shared.no, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            blurVisualEffectView.removeFromSuperview()
        }
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        self.view.addSubview(blurVisualEffectView)
        self.present(alert, animated: true, completion: nil)
    }
    fileprivate func passwordAlert(_ presentation: Presentation) {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        
        var name = String()
        let alert = UIAlertController(title: LockPresentationAlert.shared.lockedPresentation, message: LockPresentationAlert.shared.enterPassword, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: LockPresentationAlert.shared.ok, style: .default) { _ in
            let answer = alert.textFields![0]
            name = answer.text ?? ""
            
            if presentation.pass == name {
                self.pushPresentationStart(presentation)
            } else { print ("Access is denied") }
            blurVisualEffectView.removeFromSuperview()
        }
        
        let cancelAction = UIAlertAction(title: LockPresentationAlert.shared.cancel, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            blurVisualEffectView.removeFromSuperview()
        }
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        self.view.addSubview(blurVisualEffectView)
        self.present(alert, animated: true, completion: nil)
    }
    fileprivate func feelReportsAlert() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        
        let alert = UIAlertController(title: FillReportsAlert.shared.sorry, message: FillReportsAlert.shared.presentNotAvailable, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: FillReportsAlert.shared.ok, style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            blurVisualEffectView.removeFromSuperview()
        }
        
        alert.addAction(submitAction)
        
        self.view.addSubview(blurVisualEffectView)
        self.present(alert, animated: true, completion: nil)
    }
}
