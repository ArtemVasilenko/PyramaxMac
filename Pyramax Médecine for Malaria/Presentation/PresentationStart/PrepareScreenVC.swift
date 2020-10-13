import UIKit

class PrepareScreenVC: UIViewController {
    
    @IBOutlet weak var changeLogoButtonOutlet: UIButton!
    @IBOutlet weak var selectLogoButton: UIButton!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var lastnameTxtField: UITextField!
    @IBOutlet weak var descriptionTextViewOutlet: UITextView!
    @IBOutlet weak var continueButtonOutlet: UIButton!
    
    var slideValues = SlideValues()
    
    fileprivate func buttonsDesign() {
        self.changeLogoButtonOutlet.layer.cornerRadius = 5
        self.changeLogoButtonOutlet.layer.borderWidth = 1.0
        self.changeLogoButtonOutlet.layer.borderColor = #colorLiteral(red: 0.5879417062, green: 0.6257477999, blue: 0.6644088626, alpha: 1)
        self.changeLogoButtonOutlet.clipsToBounds = true
        
        self.descriptionTextViewOutlet.layer.cornerRadius = 5
        self.changeLogoButtonOutlet.layer.borderWidth = 1.0
        self.changeLogoButtonOutlet.layer.borderColor = #colorLiteral(red: 0.5879417062, green: 0.6257477999, blue: 0.6644088626, alpha: 1)
        self.changeLogoButtonOutlet.clipsToBounds = true
        
        self.continueButtonOutlet.layer.masksToBounds = true
        self.continueButtonOutlet.layer.cornerRadius = 8.0
        self.continueButtonOutlet.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4352941176, blue: 0.2509803922, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonsDesign()
        self.nameTxtField.text = User.shared.name
        self.lastnameTxtField.text = User.shared.lastName
        
        Logos.shared.fillInLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(Logos.shared)
    }
    
    @IBAction func startSlidesActionButton(_ sender: UIButton) {
        startPresentAlert()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectLogoButtonAction(_ sender: UIButton) {
        
//        let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.presentStart.rawValue, bundle: nil)
//        let controller: SelectLogoViewController = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.selectLogoVC.rawValue) as! SelectLogoViewController
        
        let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.presentStart.rawValue, bundle: nil)
        let controller: LogoTableViewController = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.selectLogoTableView.rawValue) as! LogoTableViewController
        
        self.present(controller, animated: true, completion: nil)
        
    }
    
    fileprivate func startPresentAlert() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        
        let alert = UIAlertController(title: StartPresentationAlert.shared.startPresentation, message: StartPresentationAlert.shared.realyStart, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: StartPresentationAlert.shared.startNow, style: .default) { _ in
            
            let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.presentStart.rawValue, bundle: nil)
            let controller: SlideViewController = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.slideVC.rawValue) as! SlideViewController
            
            controller.modalPresentationStyle = .fullScreen
            controller.slideValues = self.slideValues
            controller.uploadPreviewSlide()
            
            let descriptionText = self.descriptionTextViewOutlet.text ?? ""
            let nameText = self.nameTxtField.text ?? ""
            let lastNameText = self.lastnameTxtField.text ?? ""
            
            self.present(controller, animated: true) {
                controller.previewDescription.text = descriptionText
                controller.previewUserName.text = "\(nameText) \(lastNameText)"
            }
            
            blurVisualEffectView.removeFromSuperview()
        }
        
        let cancelAction = UIAlertAction(title: StartPresentationAlert.shared.later, style: .default) { _ in
            
            let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.main.rawValue, bundle: nil)
            
            let controller: TabBarVC = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.tabBarVC.rawValue) as! TabBarVC
            controller.modalPresentationStyle = .fullScreen
            
            
            self.present(controller, animated: true) {
                controller.updateTabBar(slideValues: self.slideValues, presentCVTouch: false, presentButtonHidden: false, slideNumber: 0)
            }
            
            alert.dismiss(animated: true, completion: nil)
            blurVisualEffectView.removeFromSuperview()
        }
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        self.view.addSubview(blurVisualEffectView)
        self.present(alert, animated: true, completion: nil)
    }
}

