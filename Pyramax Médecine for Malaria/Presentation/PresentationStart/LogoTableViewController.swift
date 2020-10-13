import UIKit

class LogoTableViewController: UIViewController {
    @IBOutlet weak var logoTableView: UITableView!
    @IBOutlet weak var selectButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoTableView.allowsMultipleSelection = true
        self.selectButtonOutlet.isEnabled = false
        self.selectButtonOutlet.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        self.selectButtonOutlet.layer.masksToBounds = true
        self.selectButtonOutlet.layer.cornerRadius = 8.0

    }
    @IBAction func selectButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            Logos.shared.fillInLogo()
        }
    }
}

// MARK: - TableView delegate

extension LogoTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Logos.shared.listLogo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("!!!!Logos.shared.listLogo \(Logos.shared.listLogo)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LogoTableViewCell
        
        cell.logoImageView.image = Logos.shared.listLogo[indexPath.row].image
        cell.selectLogoImageView.isHidden = !Logos.shared.listLogo[indexPath.row].choose
        
        if Logos.shared.listLogo.contains(where: { $0.choose == true }) {
            self.selectButtonOutlet.isEnabled = true
            self.selectButtonOutlet.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4352941176, blue: 0.2509803922, alpha: 1)

        } else {
            self.selectButtonOutlet.isEnabled = false
            self.selectButtonOutlet.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        }
        
        return cell
    }
    
    
    fileprivate func chooseLogo(_ indexPath: IndexPath) {
        print("You selected logo cell #\(indexPath.item)!")
        // kolhoz variant:
        //        if Logos.shared.listLogo[indexPath.row].choose {
        //            Logos.shared.listLogo[indexPath.row].choose = false
        //        } else {
        //            Logos.shared.listLogo[indexPath.row].choose = true
        //        }
        // norm variant:
        Logos.shared.listLogo[indexPath.row].choose = !Logos.shared.listLogo[indexPath.row].choose
        
        
    
        self.logoTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.chooseLogo(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.chooseLogo(indexPath)
    }
    
}
