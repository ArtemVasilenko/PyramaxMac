import UIKit

class SelectCoverVC: UIViewController {
    
    @IBOutlet weak var standartCoverButton: UIButton!
    @IBOutlet weak var customizeButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
        
    var slidesValues = SlideValues()

    
    //MARK: - alert!!!
    fileprivate func startPresentAlert() {
        
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        
        let alert = UIAlertController(title: StartPresentationAlert.shared.startPresentation, message: StartPresentationAlert.shared.realyStart, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: StartPresentationAlert.shared.startNow, style: .default) { _ in
            
            let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.presentStart.rawValue, bundle: nil)
            let controller: SlideViewController = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.slideVC.rawValue) as! SlideViewController
            controller.modalPresentationStyle = .fullScreen
            controller.slideValues = self.slidesValues

//            controller.choiseStandart = self.choiseStandart
            controller.uploadPreviewSlide()

            self.present(controller, animated: true, completion: nil)
            
            blurVisualEffectView.removeFromSuperview()
        }
        
        let cancelAction = UIAlertAction(title: StartPresentationAlert.shared.later, style: .default) { _ in
            
            let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.main.rawValue, bundle: nil)
            let controller: TabBarVC = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.tabBarVC.rawValue) as! TabBarVC
            controller.modalPresentationStyle = .fullScreen
            
            self.present(controller, animated: true) {
                
                controller.updateTabBar(slideValues: self.slidesValues, presentCVTouch: false, presentButtonHidden: false, slideNumber: 0)

        }
            
            alert.dismiss(animated: true, completion: nil)
            blurVisualEffectView.removeFromSuperview()
        }
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        self.view.addSubview(blurVisualEffectView)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.standartCoverButton.alpha = 0.5
        self.customizeButton.alpha = 0.1
        self.continueButton.isEnabled = false
        self.continueButton.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        self.continueButton.layer.masksToBounds = true
        self.continueButton.layer.cornerRadius = 8.0
        
        self.standartCoverButton.addTarget(self, action: #selector(pressStandartCoverButton(sender:)), for: .touchUpInside)
        
        self.customizeButton.addTarget(self, action: #selector(pressCustomizeButton(sender:)), for: .touchUpInside)
        
    }
    
    
    @IBAction func actionButtonContinue(_ sender: UIButton) {
        if self.slidesValues.choiseStandart == true {
            self.startPresentAlert()
            
        } else {
            
            let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.presentStart.rawValue, bundle: nil)
            let controller: PrepareScreenVC = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.prepareScreenVC.rawValue) as! PrepareScreenVC
            controller.modalPresentationStyle = .fullScreen
            controller.slideValues = self.slidesValues
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelActionButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func pressStandartCoverButton(sender: UIButton) {
        self.standartCoverButton.alpha = 1
        self.customizeButton.alpha = 0.1
        self.slidesValues.choiseStandart = true
        self.continueButton.isEnabled = true
        self.continueButton.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4352941176, blue: 0.2509803922, alpha: 1)
    }
    
    @objc func pressCustomizeButton(sender: UIButton) {
        self.standartCoverButton.alpha = 0.5
        self.customizeButton.alpha = 1
        self.slidesValues.choiseStandart = false
        self.continueButton.isEnabled = true
        self.continueButton.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4352941176, blue: 0.2509803922, alpha: 1)

    }
}
