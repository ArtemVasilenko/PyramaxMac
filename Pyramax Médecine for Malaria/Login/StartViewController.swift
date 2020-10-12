import UIKit
import Alamofire

class StartViewController: UIViewController {
    
    class Connectivity {
        class func isConnectedToInternet() -> Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    @IBOutlet weak var forgotPasswordButtonOutlet: UIButton!
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Connectivity.isConnectedToInternet() == false {
            self.registerButtonOutlet.isEnabled = false
        }
        
    }
    
    @IBAction func enterButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
    }
    
}
