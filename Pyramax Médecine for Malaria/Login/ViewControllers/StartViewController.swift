import UIKit
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    @IBOutlet weak var forgotPasswordButtonOutlet: UIButton!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Connectivity.isConnectedToInternet() == false {
            self.registerButtonOutlet.isEnabled = false
        }
        
        buttonRounder()
        setupTextFields()
        self.spinner.isHidden = true
        
        self.mailTextField.text = self.defaults.object(forKey: "email") as? String
        
        if Connectivity.isConnectedToInternet() == false {
            self.registerButtonOutlet.isEnabled = false
            self.forgotPasswordButtonOutlet.isEnabled = false
        }
        
        // Add tap to hide keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Up Keyboard when edit
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(tapped4))
        tap4.numberOfTapsRequired = 4
        view.addGestureRecognizer(tap4)
        
    }
    
    private final func buttonRounder() {
        if enterButton != nil {
            enterButton.layer.cornerRadius = 15
            enterButton.layer.borderWidth = 1
            enterButton.layer.borderColor = UIColor.black.cgColor
            enterButton.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4352941176, blue: 0.2509803922, alpha: 1)
        }
    }
    
    private final func setupTextFields() {
        if mailTextField != nil && passwordTextField != nil {
            mailTextField.delegate = self
            mailTextField.tag = 0
            passwordTextField.delegate = self
            passwordTextField.tag = 1
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - (keyboardSize.height / 7)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func tapped4() {
        mailTextField.text = "ikholodoff@gmail.com"
        passwordTextField.text = "holodov"
    }
    
    @IBAction func enterButtonAction(_ sender: UIButton) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        guard mailTextField.text != "", passwordTextField.text != "" else {
            self.failAlert()
            return
        }
        
        guard let email = mailTextField.text,
            let pass = passwordTextField.text else {return}
        //        let user = User(email: email, pass: pass)
        //        user.save()
        print("email:", email, pass)
                
        self.login(userEmail: email, userPassword: pass)
    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: ForgotPasswordViewController = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordViewController
        controller.modalPresentationStyle = .fullScreen
        
        self.present(controller, animated: true, completion: nil)
    }
    
}


// MARK: - API Login
extension StartViewController {
    
    fileprivate func failAlert() {
        self.spinner.isHidden = true
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        
        let alert = UIAlertController(title: InvalidNameOrPassword.shared.invalidValues, message: InvalidNameOrPassword.shared.pleaseCorrect, preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: InvalidNameOrPassword.shared.ok, style: .default) { _ in
            blurVisualEffectView.removeFromSuperview()
        }
        
        alert.addAction(submitAction)
        
        self.view.addSubview(blurVisualEffectView)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func login(userEmail: String, userPassword: String) {
        
        guard Connectivity.isConnectedToInternet() else {
            
            if self.defaults.object(forKey: "email") != nil && self.defaults.object(forKey: "password") != nil {
                if userEmail == self.defaults.object(forKey: "email") as! String && userPassword == self.defaults.object(forKey: "password") as! String {
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
            self.spinner.isHidden = true
            self.internetAlert(titleAlert: InternetError.shared.sorry, message: InternetError.shared.internetIsNotConected, titleButton: InternetError.shared.ok)
            return
        }
        
        let ip = "http://92.222.71.100/v1"
        let apiRequest = ip + "/sessions?session[email]=\(userEmail)&session[password]=\(userPassword)"
        request(apiRequest, method: .post)
            .validate()
            .responseJSON {responseJSON in
                switch responseJSON.result  {
                case .success(let value):
                    guard let jsonArray = value as? [String: Any] else {
                        print("guard let jsonArray = value as? [[String: Any]] else")
                        return
                    }
                    
                    let jsonArrayData = jsonArray["data"]! as? [String: Any]
                    print("jsonArrayData:", jsonArrayData!)
                    
                    let name = jsonArrayData!["name"]
                    User.shared.name = String(describing: name)
                    User.shared.name = User.shared.name.replacingOccurrences(of: "Optional(", with: "")
                    User.shared.name = User.shared.name.replacingOccurrences(of: ")", with: "")
                    
                    let lastName = jsonArrayData!["last_name"]
                    User.shared.lastName = String(describing: lastName)
                    User.shared.lastName = User.shared.lastName.replacingOccurrences(of: "Optional(", with: "")
                    User.shared.lastName = User.shared.lastName.replacingOccurrences(of: ")", with: "")
                    
                    let token = jsonArrayData!["api_token"]
                    User.shared.token = String(describing: token)
                    User.shared.token = User.shared.token.replacingOccurrences(of: "Optional(", with: "")
                    
                    User.shared.email = userEmail
                    
                    let avatar = jsonArrayData!["avatar"]
                    var ava = avatar as! String
                    ava = "http://92.222.71.100" + ava
                    let url = URL(string: ava)!
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            User.shared.avatar = image
                        }
                    }
                    print(User.shared.avatar)
                    
                    User.shared.token.removeLast()
                    print("User.shared.token :", User.shared.token)
                    
                    let id = jsonArrayData!["id"]
                    User.shared.id = Int(String(describing: id!)) ?? 0
                    print("User.shared.id =", User.shared.id)
                    
                    self.defaults.set("\(userEmail)", forKey: "email")
                    self.defaults.set("\(userPassword)", forKey: "password")
                    
                    // когда выполниться, запускаем
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    
                case .failure(let error):
                    print("case .failure(let error):", error)
                    self.failAlert()
                }
        }
    }
}

extension StartViewController {
    
    fileprivate func internetAlert(titleAlert: String, message: String, titleButton: String) {
        
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
