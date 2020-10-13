import UIKit

class PresentationStartVC: UIViewController {
    
    private var idPresent : Int!
    
    @IBOutlet weak var continueButtonOutlet: UIButton!
    @IBOutlet weak var slidesTableView: UITableView!
    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var audioSwitchOtlet: UISwitch!
    
    
    var presentation : Presentation! {
        didSet {
            self.idPresent = presentation.id
        }
    }
    
    var slidesValues = SlideValues()
    
    override func viewDidLoad() {
        self.slidesValues.slides = Slides(self.idPresent)
        self.slidesValues.presentationName = self.presentation.text ?? "error"
        
        self.continueButtonOutlet.layer.masksToBounds = true
        self.continueButtonOutlet.layer.cornerRadius = 8.0
        self.continueButtonOutlet.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.4352941176, blue: 0.2509803922, alpha: 1)
    }
    
    fileprivate func openedViewController() {
        let storyboard: UIStoryboard = UIStoryboard(name: Storyboards.nameSB.presentStart.rawValue, bundle: nil)
        let controller: SelectCoverVC = storyboard.instantiateViewController(withIdentifier: Storyboards.nameIdentity.selectCoverVC.rawValue) as! SelectCoverVC
        controller.modalPresentationStyle = .fullScreen
        controller.slidesValues = self.slidesValues
        
        
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func startSelectCoverVCAction(_ sender: UIButton) {
        openedViewController()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func autoSlideSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            self.slidesValues.autoSlide = true
            print("auto slide = ON")
        } else  {
            self.slidesValues.autoSlide = false
            print("auto slide = OFF")
        }
        
    }
    
    @IBAction func audioSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            self.slidesValues.playAudio = true
            print("audio = ON")
        } else {
            self.slidesValues.playAudio = false
            print("audio = OFF")
        }
    }
    

}

extension PresentationStartVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.slidesValues.slides.listSlides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PresentationStartTableViewCell
        
        let slide = self.slidesValues.slides.listSlides[indexPath.row]
        
        if indexPath.row < 9 {
            cell.slideName.text = "0\(indexPath.row + 1)   \(slide.name)"
        } else {
            cell.slideName.text = "\(indexPath.row + 1)   \(slide.name)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "SlideVCSB", bundle: nil)
//        let controller: SlideVC = storyboard.instantiateViewController(withIdentifier: "ControllerIdentifier") as! SlideVC
//        
//        controller.slide = slides.listSlides[indexPath.row]
//        
//        controller.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        controller.modalPresentationStyle = .overCurrentContext
//        self.present(controller, animated: true, completion: nil)
    }
    
}
