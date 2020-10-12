import UIKit
import Alamofire

class WelcomeViewController: UIViewController {
    
    class Connectivity {
        class func isConnectedToInternet() -> Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    fileprivate func designButtons() {
        self.loginButtonOutlet.layer.masksToBounds = true
        self.loginButtonOutlet.layer.cornerRadius = 8.0
        self.loginButtonOutlet.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4352941176, blue: 0.2509803922, alpha: 1)
        
        self.registerButtonOutlet.layer.masksToBounds = true
        self.registerButtonOutlet.layer.cornerRadius = 8.0
        self.registerButtonOutlet.layer.borderWidth = 1.0
        self.registerButtonOutlet.layer.borderColor = UIColor.orange.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designButtons()
        
        if Connectivity.isConnectedToInternet() == false {
            self.registerButtonOutlet.isEnabled = false
        }
        
    }
    
}
